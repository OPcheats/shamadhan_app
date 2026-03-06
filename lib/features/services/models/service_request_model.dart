/// Accumulates data across the multi-step service request flow.
class ServiceRequestModel {
  final String service;
  final String type;     // 'Repair' | 'New' (empty for Aya)
  final String ayaType;  // 'Child Care' | 'Elder Care' | 'Patient Care' | 'House Help'
  final String clientName;
  final String phone;
  final String address;
  final String preferredDate;
  final String preferredTime;
  final String notes;

  const ServiceRequestModel({
    this.service = '',
    this.type = '',
    this.ayaType = '',
    this.clientName = '',
    this.phone = '',
    this.address = '',
    this.preferredDate = '',
    this.preferredTime = '',
    this.notes = '',
  });

  ServiceRequestModel copyWith({
    String? service,
    String? type,
    String? ayaType,
    String? clientName,
    String? phone,
    String? address,
    String? preferredDate,
    String? preferredTime,
    String? notes,
  }) {
    return ServiceRequestModel(
      service: service ?? this.service,
      type: type ?? this.type,
      ayaType: ayaType ?? this.ayaType,
      clientName: clientName ?? this.clientName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      preferredDate: preferredDate ?? this.preferredDate,
      preferredTime: preferredTime ?? this.preferredTime,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'client_name': clientName,
        'phone': phone,
        'service': service,
        'service_type': type,
        'aya_type': ayaType,
        'address': address,
        'preferred_date': preferredDate,
        'preferred_time': preferredTime,
        'notes': notes,
      };
}
