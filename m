From: "Effrem Norwood" <eff@exstor.com>
Subject: Re: large devices (3ware)
Date: Wed, 21 Aug 2002 15:22:53 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200208211522.g7LFMrZ59772@cynaptic.com>
References: <Pine.LNX.4.44.0208211035120.1498-100000@uplift.swm.pp.se>
Reply-To: effrem.norwood@exstor.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0208211035120.1498-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I am considering a 3ware 7500-12 (12 channel IDE raid controller) and 12 
> 120 gig drives in a single large RAID5. Am I correct that Linux (latest 
> Redhat 7.3 shipped 2.4.18 kernel) can handle devices up to 2 terabyte and 
> that this raid5 (1320 gig) would work as expected as one single file 
> system (ext3) ? Anyone actually have something similar up and running and 
> can verify that it works?

Hi Mikael,

Yes, it will work just fine. We have several of the 3ware 7500-12's here with
exactly the setup you're looking at, save for we use Debian. 3ware makes a
driver for Redhat and the kernel if recompiled with the option has one built
in. It's a solid setup.

Best,

Effrem Norwood
