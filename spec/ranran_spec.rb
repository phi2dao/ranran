RSpec.describe Ranran::Bucket do
  before(:example) do
    @bucket = Ranran::Bucket.new
  end

  it "is empty when first created" do
    expect(@bucket).to be_empty
  end

  it "returns nil when examining an item that doesn't exist" do
    expect(@bucket[:foo]).to be_nil
  end

  it "allows items to be added with #add" do
    @bucket.add :foo, 1

    expect(@bucket[:foo]).to eql(1)
  end

  it "allows items to be added with #[]=" do
    @bucket[:foo] = 1

    expect(@bucket[:foo]).to eql(1)
  end

  it "doesn't allow non-numeric weights" do
    expect { @bucket.add :foo, :bar }.to raise_error(TypeError)
  end

  it "is equal to an empty bucket" do
    expect(@bucket).to eql(Ranran::Bucket.new)
  end

  context "after an item has been added" do
    before(:example) do
      @bucket.add :foo, 1
    end

    it "is not empty" do
      expect(@bucket).to_not be_empty
    end

    it "tracks weight" do
      expect(@bucket.weight).to eql(1)
    end

    it "allows the added item to be examined" do
      expect(@bucket[:foo]).to eql(1)
    end

    context "when randomizing" do
      it "returns the item via #choose" do
        expect(@bucket.choose).to eql(:foo)
      end

      it "returns the item via #take" do
        expect(@bucket.take).to eql(:foo)
      end

      it "returns the item via #take!" do
        expect(@bucket.take!).to eql(:foo)
      end

      it "is empty after returning an item via #take!" do
        @bucket.take!

        expect(@bucket).to be_empty
      end
    end

    it "allows the added item to be overwritten" do
      @bucket[:foo] = 2

      expect(@bucket[:foo]).to eql(2)
    end

    context "after overwritting an item" do
      before(:example) do
        @bucket[:foo] = 2
      end

      it "tracks weight" do
        expect(@bucket.weight).to eql(2)
      end
    end

    it "allows the added item to be deleted" do
      expect(@bucket.delete :foo).to eql([:foo, 1])
    end

    context "after the item has been deleted" do
      before(:example) do
        @bucket.delete :foo
      end

      it "actually deletes the item" do
        expect(@bucket).to be_empty
      end

      it "tracks weight" do
        expect(@bucket.weight).to eql(0)
      end
    end
  end

  context "after multiple items have been added" do
    before(:example) do
      @bucket.add :foo, 1
      @bucket.add :foo, 1
      @bucket.add :bar, 2
    end

    it "combines identical items" do
      expect(@bucket[:foo]).to eql(2)
    end

    it "allows all items to be examined" do
      expect(@bucket.items).to eql([[:foo, 2], [:bar, 2]])
    end

    context "when randomizing" do
      it "returns items via #choose(n)" do
        expect(@bucket.choose(3).length).to eql(3)
      end

      it "returns items via #take(n)" do
        expect(@bucket.take(3).length).to eql(3)
      end

      it "returns items via #take!(n)" do
        expect(@bucket.take(3).length).to eql(3)
      end

      it "is empty after returning all items via #take!(n)" do
        @bucket.take! 3

        expect(@bucket).to be_empty
      end
    end

    it "is equal to a bucket with the same items" do
      other_bucket = Ranran::Bucket.new
      other_bucket.add :foo, 2
      other_bucket.add :bar, 2

      expect(@bucket).to eql(other_bucket)
    end

    it "allows duplication" do
      expect(@bucket).to eql(@bucket.dup)
    end
  end
end