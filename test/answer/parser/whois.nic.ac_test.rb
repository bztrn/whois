require 'test_helper'
require 'whois/answer/parser/whois.nic.ac.rb'

class AnswerParserWhoisNicAcTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicAc
    @host   = "whois.nic.ac"
  end


  def test_domain
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = "google.ac"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_variable_get(:"@domain")

    parser    = @klass.new(load_part('/available.txt'))
    expected  = "u34jedzcq.ac"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_variable_get(:"@domain")
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).domain_id }
  end


  def test_status
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_variable_get(:"@status")

    parser    = @klass.new(load_part('/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_variable_get(:"@status")
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
    assert !@klass.new(load_part('/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).expires_on }
  end


  def test_registrar
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).registrar }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).registrar }
  end

  def test_registrant
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).registrant }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).registrant }
  end

  def test_admin
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).admin }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).admin }
  end

  def test_technical
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).technical }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).technical }
  end


  def test_nameservers
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).nameservers }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).nameservers }
  end


  def test_changed?
    parser_r1 = @klass.new(load_part('/registered.txt'))
    parser_r2 = @klass.new(load_part('/registered.txt'))
    parser_a1 = @klass.new(load_part('/available.txt'))
    parser_a2 = @klass.new(load_part('/available.txt'))

    assert !parser_r1.changed?(parser_r1)
    assert !parser_r1.changed?(parser_r2)
    assert  parser_r1.changed?(parser_a1)

    assert !parser_a1.changed?(parser_a1)
    assert !parser_a1.changed?(parser_a2)
    assert  parser_a1.changed?(parser_r1)
  end

  def test_unchanged?
    parser_r1 = @klass.new(load_part('/registered.txt'))
    parser_r2 = @klass.new(load_part('/registered.txt'))
    parser_a1 = @klass.new(load_part('/available.txt'))
    parser_a2 = @klass.new(load_part('/available.txt'))

    assert  parser_r1.unchanged?(parser_r1)
    assert  parser_r1.unchanged?(parser_r2)
    assert !parser_r1.unchanged?(parser_a1)

    assert  parser_a1.unchanged?(parser_a1)
    assert  parser_a1.unchanged?(parser_a2)
    assert !parser_a1.unchanged?(parser_r1)
  end

end
