From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Software RAID 0+1 with mdadm.
Date: Thu, 27 Jan 2005 10:50:43 -0500
Message-ID: <200501271548.j0RFml910827@www.watkins-home.com>
References: <Pine.LNX.4.61.0501270801560.21209@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0501270801560.21209@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Holger Kiehl' <Holger.Kiehl@dwd.de>, 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

RAID10 will work with an odd number of disks!  If really is cool!

But, since you need control of what is where, you don't want RAID10.

You should create RAID1 arrays.  Each of your RAID1 arrays should have 2
disks, each on a different controller/channel.  Then create a single RAID0
array out of the RAID1 arrays.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Holger Kiehl
Sent: Thursday, January 27, 2005 3:13 AM
To: Neil Brown
Cc: linux-raid
Subject: Re: Software RAID 0+1 with mdadm.

>>
>> I have since upgraded to mdadm 1.8 and setup a RAID10. However I need
>> something that is production worthy. Is a RAID10 something I could rely
>> on as well? Also under a RAID10 how do you tell it which drives you want
>> mirrored?
>
> raid10 is 2.6 only, but should be quite stable.
> You cannot tell it which drives to mirror because you shouldn't care.
> You just give it a bunch of identical drives and let it put the data
> where it wants.
>
> If you really want to care (and I cannot imagine why you would - all
> drives in a raid10 are likely to get similar load) then you have to
> build it "by hand" - a raid0 of multiple raid1s.
>
But what about redundancy? The only reason why on some systems I choose
raid 1+0 and not raid10, is that I want the raid 1 always on two different
controllers or channels. So if there is some problem with the SCSI bus
you will only loose one half of your array. I think with raid10 it
can be that you loose your complete array, because a whole raid1 can
sit on a single controller/channel. Is this assumption correct, or
does raid10 have some magic to solve this?

Thanks,
Holger
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

