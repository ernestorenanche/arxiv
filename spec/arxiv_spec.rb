require 'spec_helper'

describe Arxiv do
  before :all do
    @manuscript = Arxiv.get('1202.0819') # export.arxiv.org/api/query?id_list=1202.0819
  end

  it "should fetch the link to the manuscript's page on arXiv" do
    @manuscript.arxiv_url.should == "http://arxiv.org/abs/1202.0819v1"
  end
  it "should fetch the datetime when the manuscript was first published to arXiv" do
    @manuscript.created_at.should == DateTime.parse("2012-02-03T21:00:00Z")
  end
  it "should fetch the datetime when the manuscript was last updated" do
    @manuscript.updated_at.should == DateTime.parse("2012-02-03T21:00:00Z")
  end
  it "should fetch the manuscript's title" do
    @manuscript.title.should == "Laser frequency comb techniques for precise astronomical spectroscopy"
  end
  it "should fetch the manuscript's abstract" do
    @manuscript.abstract.should == "Precise astronomical spectroscopic analyses routinely assume that individual pixels in charge-coupled devices (CCDs) have uniform sensitivity to photons. Intra-pixel sensitivity (IPS) variations may already cause small systematic errors in, for example, studies of extra-solar planets via stellar radial velocities and cosmological variability in fundamental constants via quasar spectroscopy, but future experiments requiring velocity precisions approaching ~1 cm/s will be more strongly affected. Laser frequency combs have been shown to provide highly precise wavelength calibration for astronomical spectrographs, but here we show that they can also be used to measure IPS variations in astronomical CCDs in situ. We successfully tested a laser frequency comb system on the Ultra-High Resolution Facility spectrograph at the Anglo-Australian Telescope. By modelling the 2-dimensional comb signal recorded in a single CCD exposure, we find that the average IPS deviates by <8 per cent if it is assumed to vary symmetrically about the pixel centre. We also demonstrate that series of comb exposures with absolutely known offsets between them can yield tighter constraints on symmetric IPS variations from ~100 pixels. We discuss measurement of asymmetric IPS variations and absolute wavelength calibration of astronomical spectrographs and CCDs using frequency combs."
  end
  it "should fetch the manuscript's comment" do
    @manuscript.comment.should == "11 pages, 7 figures. Accepted for publication in MNRAS"
  end

  context "authors" do
    it "should fetch the authors" do
      @manuscript.authors.should have(5).authors
    end
    it "should fetch the author's affiliations" do
      author = @manuscript.authors.first
      author.affiliations.should include("Swinburne University of Technology")
    end
  end

  context "categories" do
    it "should fetch the manuscript's categories" do
      @manuscript.categories.map(&:abbreviation).should include("astro-ph.IM", "astro-ph.CO", "astro-ph.EP")
    end
    it "should fetch the category's abbreviation" do
      @manuscript.primary_category.abbreviation.should == "astro-ph.IM"
    end
    it "should fetch the category's description" do
      @manuscript.primary_category.description.should == "Physics - Instrumentation and Methods for Astrophysics"
    end
    it "should fetch the category's #long_description" do
      @manuscript.primary_category.long_description.should == "astro-ph.IM (Physics - Instrumentation and Methods for Astrophysics)"
    end

  end

  context "links" do
    let(:pdf) {@manuscript.links.last}
    it "should fetch the link's content type" do
      pdf.content_type.should == 'application/pdf'
    end
    it "should fetch the link's url" do
      pdf.url.should == 'http://arxiv.org/pdf/1202.0819v1'
    end
  end

  context "instance methods" do
    describe "revision?" do
      it "should return true if the manuscript has been revised" do
        @manuscript.should_not be_revision
      end
    end
    describe "arxiv_versioned_id" do
      it "should return the unique document id used by arXiv" do
        @manuscript.arxiv_versioned_id.should == '1202.0819v1'
      end
    end
    describe "arxiv_id" do
      it "should return the unique document id used by arXiv" do
        @manuscript.arxiv_id.should == '1202.0819'
      end
    end
    describe "version" do
      it "should return the manuscript's version number" do
        @manuscript.version.should == 1
      end
    end
    describe "content_types" do
      it "return an array of available content_types" do
        @manuscript.content_types.should include("text/html", "application/pdf")
        @manuscript.content_types.should have(2).content_types
      end
    end
    describe "available_in_pdf?" do
      it "should return true if the manuscript is available to be downloaded in PDF" do
        @manuscript.should be_available_in_pdf
      end
    end
    describe "pdf_url" do
      it "should return the url to download the manuscript in PDF format" do
        @manuscript.pdf_url.should == 'http://arxiv.org/pdf/1202.0819v1'
      end
    end
  end

end