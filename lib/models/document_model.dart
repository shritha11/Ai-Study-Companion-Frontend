class DocumentModel {
    final String documentName;
    final String originalFilename;
    final String uploadedAt;
    final int totalChunks;
    final String storedFilename;

    DocumentModel({
        required this.documentName, 
        required this.originalFilename, 
        required this.uploadedAt,
        required this.totalChunks, 
        required this.storedFilename,
    });

    factory DocumentModel.fromJson(Map<String, dynamic> json) {
        return DocumentModel(
            documentName: json["document_name"], 
            originalFilename: json["original_filename"], 
            uploadedAt: json["uploaded_at"],
            totalChunks: json["total_chunks"], 
            storedFilename: json["stored_filename"],
        );
    }
}
