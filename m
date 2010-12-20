From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/29] OLCE, migrations and raid10 takeover
Date: Tue, 21 Dec 2010 08:59:19 +1100
Message-ID: <20101221085919.34ce91ce@notabene.brown>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
	<20101216222058.03132812@notabene.brown>
	<BE2BFE91933D1B4089447C644860408066B84342@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066B84342@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 20 Dec 2010 08:27:38 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> Neil,
> 
> How we can help you to speed up your work?
> 

Thanks for the offer, but you probably cannot at the moment.

You (collectively) have already done a great job in exploring the problem
space and hitting lots of different issues and attempted solutions.
That allows me to get a good understanding of what is required and where the
difficulties and important details etc.
I can see that the solutions you have come up with aren't ideal (aren't
really easy to maintain and are subtly wrong in some cases), largely because
the infrastructure that you were working in was too restrictive.

Now that I have that big, detailed, picture, I can re-write the infrastructure
to (hopefully) make it easy to implement the same functionality in a much
clearer and more maintainable way.  And I'm getting close.

Once that is done, you can certainly help by modifying the IMSM specific code
to fit the new model (which I will try to document a bit better).


Thanks,
NeilBrown
