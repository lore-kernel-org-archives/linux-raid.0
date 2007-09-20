From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Thu, 20 Sep 2007 11:47:38 -0700 (PDT)
Message-ID: <20070920184738.441FD10208C@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan> <20070919014919.DF19D10215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan> <20070919174956.9497310209D@medulla.enet.sharplabs.com> <46F292E2.1090700@tmr.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <46F292E2.1090700@tmr.com> (message from Bill Davidsen on Thu, 20
	Sep 2007 11:33:54 -0400)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Bill Davidsen wrote:
: Dean S. Messing wrote:
  > 
 snip

: Do you want to tune it to work well now or work well in the final 
: configuration? There is no magic tuning which is best for every use, if 
: there was it would be locked in and you couldn't change it.

I want it to work well in the final config. I'm just now learning
about benchmarking with tools like bonnie++.  In my naivety, I thought
that `hdparm -t' "told all", at least for reads.

: > Aside: I have found RAID quite frustrating.  With the original two
: > disks I was getting 120-130 MB/s in RAID 0.  I would think that for
: > the investment of a 3rd drive I ought to get the modicum of
: > redundancey I expect and keep the speed (at least on reads) w/o
: > sacrificing anything.  But it appears I actually lost something for my
: > investment.  I'm back to the speed of single drives with the modicum
: > of redundancey that RAID 5 gives.  Not a very good deal.
: RAID-5 and RAID-1 performance are popular topic, reading the archives 
: may shed more light on that.

So I'm seeing.  I just finished wading through a long April 07
discussion on "write-though" vs. "write-back" for RAID 5.

:  After you get to LVM you can do read ahead 
: tuning on individual areas, which will allow you to do faster random 
: access on one part and faster sequential on another. *But* when you run 
: both types of access on the same physical device one or the other will 
: suffer, and with careful tuning both can be slow.

This is why simply bumping up the read ahead parameter as has been
suggested to me seems suspect.  If this was the right fix, it seems
that it would be getting set automatically by the default installation
of mdadm.


: When you get to the point where you know exactly what you are going to 
: do and how you are going to do it (layout) you can ask a better question 
: about tuning.

Well (in my extreme naivete) I had hoped that I could (just)
-- buy the extra SATA drive,
-- configure RAID 5 on all three drives, 
-- have it present itself as a single device with the speed
     of RAID 0 (on two drives), and the safety net of RAID 5, 
-- install Fedora 7 on the array,
-- use LVM to partition as I liked,
-- and forget about it.

Instead, this has turned into a many hour exercise in futility.  This
is my research machine (for signal/image processing) and the machine I
"live on".  It does many different things.  What I really need is more
disk speed (but I can't afford very high speed drives).  That's what
attracted me to RAID 0 --- which seems to have no downside EXCEPT
safety :-).

So I'm not sure I'll ever figure out "the right" tuning.  I'm at the
point of abandoning RAID entirely and just putting the three disks
together as a big LV and being done with it.  (I don't have quite the
moxy to define a RAID 0 array underneath it. :-)


: PS: adding another drive and going to RAID-10 with "far" configuration 
: will give you speed and reliability, at the cost of capacity. Aren't 
: shoices fun?

I don't know hat "far" configuration is, though I understand basically
what RAID-10 is.

Having that much  "wasted" space is too costly, and besides the machine
can't take but three drives internally.  If I wished to add a 4th I'd
need to buy a SATA controller. I had thought RAID 5 did exactly what
I wanted.  Unfortunately ...

Which suggests a question for you, David.  If I were to invest in a
"true hardware" RAID SATA controller (is there such a thing) would
RAID 5 across the three drives behave just like RAID 0 on two drives +
1 disk redundancy?  In other words just abandon Linux software raid?
At this point I would be willing to spring for such a card if
it were not too expensive, and if I could find a slot to put it in.
(My system is slot-challenged).

Thanks for you remarks, David.  I wish I had the time to learn how to
do all this properly with multiple LV's, different read-aheads and
write-through/write-back settings on different logical devices, but my
head is swimming and my time is short.

Dean



