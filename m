From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/29] OLCE, migrations and raid10 takeover
Date: Tue, 21 Dec 2010 23:37:14 +1100
Message-ID: <20101221233714.61b29ad9@notabene.brown>
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

An update:

 I got the code to a state where the shape of what I'm trying to do should be
 clear, though the code to do it isn't quite complete yet.
 The last commit in my devel-3.2 tree contains some incomplete code, some
 enhanced documentation for how it is supposed to work, and a to-do list
 to remind me what I should be doing next.

 If any of your people have time to look at it and possibly fill in some of
 the gaps that would be great.  I am on leave for the next 2 weeks but I'll
 be reading email and will try to respond to any question or small patches
 that arise (I won't be reviewing any long patch series though).

 Probably the most useful next step would be to fit the migration checkpoint
 patches into the new approach - that should be fairly straight forward.
 Then probably look at reshape_super and make sure it is doing the right
 thing according to the new rules.
 manage_reshape will probably need to wait until the new code has stablised a
 bit.

Thanks,

NeilBrown

