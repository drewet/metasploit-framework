# -*- coding: binary -*-

require 'rex/java/serialization'

module Msf
  module Java
    module Rmi
      module Builder
        # Builds a RMI header stream
        #
        # @param opts [Hash{Symbol => <String, Fixnum>}]
        # @option opts [String] :signature
        # @option opts [Fixnum] :version
        # @option opts [Fixnum] :protocol
        # @return [Rex::Proto::Rmi::Model::OutputHeader]
        def build_header(opts = {})
          signature = opts[:signature] || Rex::Proto::Rmi::Model::SIGNATURE
          version = opts[:version] || 2
          protocol = opts[:protocol] || Rex::Proto::Rmi::Model::STREAM_PROTOCOL

          header = Rex::Proto::Rmi::Model::OutputHeader.new(
              signature: signature,
              version: version,
              protocol: protocol)

          header
        end

        # Builds a RMI call stream
        #
        # @param opts [Hash{Symbol => <Fixnum, Array>}]
        # @option opts [Fixnum] :message_id
        # @option opts [Fixnum] :object_number Random to identify the object.
        # @option opts [Fixnum] :uid_number Identifies the VM where the object was generated.
        # @option opts [Fixnum] :uid_time Time where the object was generated.
        # @option opts [Fixnum] :uid_count Identifies different instance of the same object generated from the same VM
        #   at the same time.
        # @option opts [Fixnum] :operation On JDK 1.1 stub protocol the operation index in the interface. On JDK 1.2
        #   it is -1.
        # @option opts [Fixnum] :hash On JDK 1.1 stub protocol the stub's interface hash. On JDK1.2 is a hash
        #   representing the method to call.
        # @option opts [Array] :arguments
        # @return [Rex::Proto::Rmi::Model::Call]
        def build_call(opts = {})
          message_id = opts[:message_id] || Rex::Proto::Rmi::Model::CALL_MESSAGE
          object_number = opts[:object_number] || 0
          uid_number = opts[:uid_number] || 0
          uid_time = opts[:uid_time] ||  0
          uid_count = opts[:uid_count] || 0
          operation = opts[:operation] || -1
          hash = opts[:hash] || 0
          arguments = opts[:arguments] || []

          uid = Rex::Proto::Rmi::Model::UniqueIdentifier.new(
            number: uid_number,
            time: uid_time,
            count: uid_count
          )

          call_data = Rex::Proto::Rmi::Model::CallData.new(
            object_number: object_number,
            uid: uid,
            operation: operation,
            hash: hash,
            arguments: arguments
          )

          call = Rex::Proto::Rmi::Model::Call.new(
            message_id: message_id,
            call_data: call_data
          )

          call
        end

        # Builds a RMI dgc ack stream
        #
        # @param opts [Hash{Symbol => <Fixnum, String>}]
        # @option opts [Fixnum] :stream_id
        # @option opts [String] :unique_identifier
        # @return [Rex::Proto::Rmi::Model::DgcAck]
        def build_dgc_ack(opts = {})
          stream_id = opts[:stream_id] || Rex::Proto::Rmi::Model::DGC_ACK_MESSAGE
          unique_identifier = opts[:unique_identifier] || "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

          dgc_ack = Rex::Proto::Rmi::Model::DgcAck.new(
              stream_id: stream_id,
              unique_identifier: unique_identifier
          )

          dgc_ack
        end
      end
    end
  end
end
