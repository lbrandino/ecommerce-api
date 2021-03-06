require "rails_helper"

class Validator
    include  ActiveModel::Validations 
    attr_accessor :date
    validates :date, future_date: true
end

describe FutureDateValidator do
    subject { Validator.new } 

    context "When date is before current date" do
        before { subject.date = 1.day.ago }  

        it "Should be invalid" do
            expect(subject.valid?).to be_falsey   
        end

        it "adds an error on model " do
            subject.valid? 
            expect(subject.errors.keys).to include(:date) 
        end

    end

    context "When date is equal current date" do
        before { subject.date = Time.zone.now }  

        it "Should be invalid" do
            expect(subject.valid?).to be_falsey   
        end

        it "adds an error on model " do
            subject.valid? 
            expect(subject.errors.keys).to include(:date) 
        end
        
    end

    context "When date is greeater than current date" do
        before { subject.date = Time.zone.now + 1.day }  

        it "Should be invalid" do
            expect(subject.valid?).to be_truthy
        end
    end

end
