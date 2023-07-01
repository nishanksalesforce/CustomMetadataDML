/**
 *@Desc: A class that can be used to insert and update custom metadata records.
 **/
public class DMLCustomMetadata {
    /**
     *@desc: A method to insert a record for custom metadata object
     **/
    public void insertMetadataRecord(){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            String nameSpacePrefix =''; // if the metadata belongs to any package than include the namespace.                
            //Creating Record 
            Metadata.CustomMetadata metadataInstance =  new Metadata.CustomMetadata();
            metadataInstance.fullName = nameSpacePrefix + 'Sample_Metadata__mdt.SampleRecord';
            metadataInstance.label = 'SampleRecord';
            //adding values to fields
            Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
            customField1.field = 'SampleName__c';
            customField1.value = 'FirstRecordName';
            metadataInstance.values.add(customField1);
            Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
            customField2.field = 'Is_Displayed__c';
            customField2.value = True;
            metadataInstance.values.add(customField2);                       
            mdContainer.addMetadata(metadataInstance);  //adding record container that will be used to deploy the records in custom metadata.                        

            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
            system.debug('jobId***'+jobId);
        }
        catch(Exception ex){
            system.debug('Error while creating custom metadata.'+ex.getMessage());
        }
    }
    /**
     *@desc: A method to update the custom metadata records. 
     **/
    public void updateBulkMetadata(){
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            for(Sample_Metadata__mdt objMetadata :[SELECT Id, DeveloperName,
                                                     MasterLabel, Label, SampleName__c,
                                                     Is_Displayed__c
                                           FROM Sample_Metadata__mdt]){
                Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
                metadataRec.fullName = 'Sample_Metadata__mdt.'+objMetadata.DeveloperName;
                metadataRec.label = objMetadata.MasterLabel;
                Metadata.CustomMetadataValue customFieldtoUpdate = new Metadata.CustomMetadataValue();
                customFieldtoUpdate.field = 'Is_Displayed__c';
                customFieldtoUpdate.value = false;
                metadataRec.values.add(customFieldtoUpdate);
                mdContainer.addMetadata(metadataRec);
            }
            system.debug('mdContainer**'+mdContainer);            
            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
            system.debug('jobId***'+jobId);                                   
        }catch(exception ex){
            system.debug('Error while updating custom metadata.'+ex.getMessage());
        }       
    }    
}
