# -*- coding:binary -*-
require 'spec_helper'

require 'rex/java/serialization'
require 'rex/proto/rmi'
require 'msf/java/rmi/builder'

describe Msf::Java::Rmi::Builder do
  subject(:mod) do
    mod = ::Msf::Exploit.new
    mod.extend ::Msf::Java::Rmi::Builder
    mod.send(:initialize)
    mod
  end

  let(:default_header) { "JRMI\x00\x02\x4b" }
  let(:header_opts) do
    {
      :version  => 1,
      :protocol => Rex::Proto::Rmi::Model::MULTIPLEX_PROTOCOL
    }
  end
  let(:opts_header) { "JRMI\x00\x01\x4d" }

  let(:default_call) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\x00\x00\x00\x00\x00\x00\x00\x00"
  end
  let(:call_opts) do
    {
      message_id: Rex::Proto::Rmi::Model::CALL_MESSAGE,
      object_number: 2,
      uid_number: 0,
      uid_time: 0,
      uid_count: 0,
      operation: 0,
      hash: 0xf6b6898d8bf28643
    }
  end
  let(:opts_call) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x02\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\xf6\xb6\x89\x8d\x8b\xf2\x86\x43"
  end

  let(:default_dgc_ack) { "\x54\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" }
  let(:dgc_ack_opts) do
    {
      :unique_identifier => "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x04\x03\x02\x01"
    }
  end
  let(:opts_dgc_ack) { "\x54\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x04\x03\x02\x01" }

  describe "#build_header" do
    context "when no opts" do
      it "creates a Rex::Proto::Rmi::Model::OutputHeader" do
        expect(mod.build_header).to be_a(Rex::Proto::Rmi::Model::OutputHeader)
      end

      it "creates a default OutputHeader" do
        expect(mod.build_header.encode).to eq(default_header)
      end
    end

    context "when opts" do
      it "creates a Rex::Proto::Rmi::Model::OutputHeader" do
        expect(mod.build_header(header_opts)).to be_a(Rex::Proto::Rmi::Model::OutputHeader)
      end

      it "creates a OutputHeader with data from opts" do
        expect(mod.build_header(header_opts).encode).to eq(opts_header)
      end
    end
  end

  describe "#build_call" do
    context "when no opts" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_call).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a default Call" do
        expect(mod.build_call.encode).to eq(default_call)
      end
    end

    context "when opts" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_call(call_opts)).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a Call with data from opts" do
        expect(mod.build_call(call_opts).encode).to eq(opts_call)
      end
    end
  end

  describe "#build_dgc_ack" do
    context "when no opts" do
      it "creates a Rex::Proto::Rmi::Model::DgcAck" do
        expect(mod.build_dgc_ack).to be_a(Rex::Proto::Rmi::Model::DgcAck)
      end

      it "creates a default Call" do
        expect(mod.build_dgc_ack.encode).to eq(default_dgc_ack)
      end
    end

    context "when opts" do
      it "creates a Rex::Proto::Rmi::Model::DgcAck" do
        expect(mod.build_dgc_ack(dgc_ack_opts)).to be_a(Rex::Proto::Rmi::Model::DgcAck)
      end

      it "creates a DgcAck with data from opts" do
        expect(mod.build_dgc_ack(dgc_ack_opts).encode).to eq(opts_dgc_ack)
      end
    end
  end
end

