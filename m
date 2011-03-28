From: NeilBrown <neilb@suse.de>
Subject: Re: Something wrong with __prep_thunderdome in super-intel.c
Date: Mon, 28 Mar 2011 13:28:45 +1100
Message-ID: <20110328132845.48ca80df@notabene.brown>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
	<20110315085346.3bf9feb7@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17A9910DD@irsmsx503.ger.corp.intel.com>
	<20110322132307.34e9bb3b@notabene.brown>
	<1301020846.15264.12.camel@dwillia2-linux>
	<905EDD02F158D948B186911EB64DB3D19204D155@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D19204D155@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
List-Id: linux-raid.ids

On Fri, 25 Mar 2011 08:43:26 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:


> 
> Unfortunately this doesn't close issue. 
> 
> I've reached the same from IMSM compatibility point of view, but have in mind that unit test suit 11 fails using this approach.
> Put focus on test 5 in this suit (I'm using it, as this is the only one that fails for me) for IMSM (note that first test pass is for native metadata).
> Using your path tests 5b and 5c fails. My code fails 5c test only. I'm currently working on it.

I've got it passing all migration tests with your patch.
The '5' tests have a problem that they are trying to use both dev6 and dev7
which have the same backing device and are used for multipath testing.
I change it to use dev10 instead of dev7 and everything passes.

So I'll be releasing 3.2.1 shortly with what I've got.

Thanks,
NeilBrown

