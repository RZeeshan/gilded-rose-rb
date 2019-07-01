require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    it "Aged Brie increases in quality the older it gets" do
      items = [Item.new("Aged Brie", 2, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 1
    end

    it "The quality of an item is never more than 50" do
      items = [Item.new("Aged Brie", 2, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
    end

    it "The quality of an item is never negative" do
      items = [Item.new("Elixir of the Mongoose", 2, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end

    it "Once the sell by date has passed, quality degrades twice as fast" do
      items = [Item.new("Elixir of the Mongoose", -1, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 8
    end

    it "Sulfuras, being a legendary item, never has to be sold or decreases in quality" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 2, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 2
      expect(items[0].quality).to eq 10
    end

    it "Backstage passes increases in quality as its sell_in value approaches" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 14
      expect(items[0].quality).to eq 21
    end

    it "Backstage passes quality increases by 2 when there are 10 days or less" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 9
      expect(items[0].quality).to eq 22
    end

    it "Backstage passes quality increases by 3 when there are 5 days or less" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 4
      expect(items[0].quality).to eq 23
    end

    it "Backstage passes quality drops to 0 after the concert" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq -2
      expect(items[0].quality).to eq 0
    end

    it "Conjured items degrade in quality twice as fast as normal items" do
      items = [Item.new("Conjured Mana Cake", 3, 6), Item.new("Conjured Mana Cake", -1, 10),
               Item.new("Elixir of the Mongoose", 3, 6), Item.new("Elixir of the Mongoose", -1, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 2
      expect(items[0].quality).to eq 4
      expect(items[1].sell_in).to eq -2
      expect(items[1].quality).to eq 6

      expect(items[2].sell_in).to eq 2
      expect(items[2].quality).to eq 5
      expect(items[3].sell_in).to eq -2
      expect(items[3].quality).to eq 8
    end
  end

end
