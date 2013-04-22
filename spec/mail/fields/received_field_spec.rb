# encoding: utf-8
require 'spec_helper'

describe Mail::ReceivedField do

  it "should initialize" do
    doing { Mail::ReceivedField.new("Received: from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)") }.should_not raise_error
  end

  it "should be able to tell the time" do
    Mail::ReceivedField.new("Received: from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)").date_time.class.should == DateTime
  end

  it "should accept a string with the field name" do
    t = Mail::ReceivedField.new('Received: from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)')
    t.name.should == 'Received'
    t.value.should == 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    t.info.should == 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>'
    t.date_time.should == ::DateTime.parse('10 May 2005 17:26:50 +0000 (GMT)')
  end
  
  it "should accept a string without the field name" do
    t = Mail::ReceivedField.new('from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)')
    t.name.should == 'Received'
    t.value.should == 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    t.info.should == 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>'
    t.date_time.should == ::DateTime.parse('10 May 2005 17:26:50 +0000 (GMT)')
  end

  it "should provide an encoded value" do
    t = Mail::ReceivedField.new('from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)')
    t.encoded.should == "Received: from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000\r\n"
  end

  it "should provide an encoded value with correct timezone" do
    t = Mail::ReceivedField.new('from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 -0500 (EST)')
    t.encoded.should == "Received: from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 -0500\r\n"
  end

  it "should provide an decoded value" do
    t = Mail::ReceivedField.new('from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)')
    t.decoded.should == 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000'
  end

  it "should handle empty name-value lists with a comment only (qmail style)" do
    t = Mail::ReceivedField.new('(qmail 24365 invoked by uid 99); 25 Jan 2011 12:31:11 -0000')
    t.info.should == '(qmail 24365 invoked by uid 99)'
  end

  it "should not handle weird microsoft-powered invalid 'received' headers" do
    expect do
    Mail::ReceivedField.new('Received: from PEPWMR22082.cww.pep.pvt ([11.188.253.10]) by\r\n PEPWMR00096.cww.pep.pvt with Microsoft SMTPSVC(6.0.3790.4675); Fri, 19 Apr\r\n 2013 00:49:40 -0500\r\n')
    end.to raise_error(Mail::Field::ParseError)
  end

  it "should handle a blank value" do
    t = Mail::ReceivedField.new('')
    t.decoded.should == ''
    t.encoded.should == "Received: \r\n"
  end
  
end
