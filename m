From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: multipath weirdness
Date: Thu, 24 Oct 2002 15:51:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <45B36A38D959B44CB032DA427A6E1064012814FE@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wrote: 
> 2 questions:
> 
> 1.  How do I get multipath.o to be insmod'ed at boot time
> so that my multipath "raid" devices will start?

Someone told me to add "alias md-personality-7 multipath" to 
/etc/modules.conf.  Thanks.
[...]
> 2.  If I don't get multipath.o to insmod at boot time, then
> raid startup fails, and I get the (Raid repair) prompt.
> 
> "No problem," I think, "I'll just do this:"
> 
> 	insmod multipath (works fine)
> 	raidstart /dev/md0 (fails with "Invalid argument".
> 
> So how do i get /dev/md0 working again?

Well, it helps a lot if "persistent-superblock" is 1, not 0.  Duh.
(which reminds me I should have posted my raidtab in the first place.)

Thanks.

-- steve

 
