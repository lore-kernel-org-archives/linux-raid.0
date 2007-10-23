From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm devices building in the wrong order
Date: Tue, 23 Oct 2007 12:28:36 +1000
Message-ID: <18205.23636.513400.895816@notabene.brown>
References: <47710.64.230.0.49.1193100277.squirrel@fox2k.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from marc@fox2k.net on Monday October 22
Sender: linux-raid-owner@vger.kernel.org
To: marc@fox2k.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 22, marc@fox2k.net wrote:
> Hello,
> 
> I am having a rather urgent and annoying problem and I would appreciate
> some input from anyone who has come across this.  I have not been able to
> find a solution as of yet.  My issue deals with nested raid using mdadm,
> and it seems that upon a reboot mdadm is attempting to assemble the larger
> array before the smaller component array is created, and thus it is
> failing.
> 
> I have a degraded raid 5 array md1 whch is composed of hda1 and md0.  Upon
> a reboot, mdadm attempts to build md1 before md0 is built. It fails, so
> md1 is not build and I need to assemble it manually.
> 
> Is there a solution for this?

What order are the arrays listed in in mdadm.conf?
If md1 comes first, put it last.

Otherwise, I cannot think what might be happening.  Maybe if you
include some kernel logs that might help.


> 
> Thanks you for your time,
> 
> Marc
> 
> p.s. I would like to also take a second to express my gratitude to Neil
> Brown  for the mdadm utility.  I have found it very useful and it has made
> working with raid in linux very enjoyable and straight-forward!

Thanks :-)

NeilBrown
