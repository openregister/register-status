module RegisterDownloader
  def self.download(register)
    # Deliberately reinstantiate the manager each time.
    # This is because requesting a register has the side effect of downloading it,
    # but only the *first* time you request that register from the same manager.
    registers_client_manager = RegistersClient::RegisterClientManager.new(
      {
        api_key: Rails.configuration.try(:registers_api_key)
      }.compact
    )

    register_client = registers_client_manager.get_register(register.name.parameterize, register.register_phase.downcase, data_store: PostgresDataStore.new(register))
    register_url = register_client.instance_variable_get(:@register_url)

    register.fields_array = Record.where(key: "register:#{register.slug}")
                                .pluck("data -> 'fields' as fields")
                                .first
    register.url = register_url
    register.save
  end
end
