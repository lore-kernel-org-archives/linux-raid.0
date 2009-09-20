From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Random bit flips - better data integrity needed [Was: Re:
  mismatch_count != 0 on multiple hosts]
Date: Sun, 20 Sep 2009 17:30:03 +0200
Message-ID: <slrnhbcijr.f3a.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Freemyer <greg.freemyer@gmail.com> wrote:
> On Sat, Sep 19, 2009 at 11:10 AM, Mario 'BitKoenig' Holbe
>> And *if* spontaneously flipping bits *would* happen on single disks,
>> they would also happen on your RAID5. No RAID level except RAID2 (which
> If you want reliable data you have to build in end-to-end
> verification.

Indeed.

> etc.  In theory the whole distribution process is reliable, but by
> verifying it at the very end you gain a significant amount of
> confidence.

And cheaper, usually.

> With regards to data storage, one major step in this direction is the
> "integrity" patch that went into the kernel last winter (2.6.28?).

That's far from being end-to-end. Actually, it is even against the
end-to-end argument. End-to-end means from application to application.

> This is all pretty new obviously.  To the best of my knowledge

The End-to-End Arguments in System Design (Saltzer, Reed, and Clark,
1981) is far from being new.


regards
   Mario
-- 
reich sein heisst nicht, einen Ferrari zu kaufen, sondern einen zu
verbrennen
                                               Dietmar Wischmeier

