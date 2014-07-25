require 'spec_helper'

describe 'feeds/phishtank.feed', :feed do
  let(:provider) { 'phishtank' }
  let(:name) { 'phishtank' }

  it_fetches_url 'http://data.phishtank.com/data/online-valid.json.gz'

  describe_parsing_the_file feed_data('phishtank-sample.json.gz') do
    it "should have parsed 10 records" do
      expect(num_records_parsed).to eq(10)
    end
    it "should have filtered 0 records" do
      expect(num_records_filtered).to eq(0)
    end
    it "should have missed 0 records" do
      expect(num_records_missed).to eq(0)
    end

    describe "the records" do
      let(:record_reports) { feed_report.record_reports }
      it "should total 10" do
        expect(record_reports.count).to eq(10)
      end

      it "each record should have generated exactly one event" do
        counts = record_reports.map { |rr| rr.events.count }
        expect(counts).to eq([1,1,1,1,1,1,1,1,1,1])
      end

      describe "the event for record 0" do
        let(:record_report) { record_reports[0] }
        let(:record) { record_report.record }
        let(:event) { record_report.events.first }
        subject { event } 

        its(:type) { is_expected.to be(:phishing) }
        its(:ipv4s) { is_expected.to match_array(['31.14.23.213']) }
        its(:urls) { pending "Waiting on URL support"; is_expected.to match_array(['http://poste.it-postepay4.phpblack.com/']) }
      end
    end
  end

end



