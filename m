From: Krzysztof Adamski <k-list@adamski.org>
Subject: Re: Looking for help how to migrate 2disk RAID1 to 3 disk RAID6
Date: Wed, 01 Jan 2014 10:02:45 -0500
Message-ID: <1388588565.5058.34.camel@oxygen.netxsys.com>
References: <1388537511.5058.22.camel@oxygen.netxsys.com>
	 <52C36908.2010701@insync.za.net>
	 <1388552041.5058.25.camel@oxygen.netxsys.com>
	 <CAL1oBhrzkxKTBaBBsa=1jEG4TGj_+oTNBCa8mH=CmYyXgtpiGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAL1oBhrzkxKTBaBBsa=1jEG4TGj_+oTNBCa8mH=CmYyXgtpiGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas M <tomas@slax.org>
Cc: Pieter De Wit <pieter@insync.za.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2014-01-01 at 08:15 +0100, Tomas M wrote:
> >> RAID Level 6 requires a minimum of 4 drives to implement
> >>
> > I have seen messages by Neil from 2011 that he was planning to remove
> > this silly minimum requirement of 4 drive for RAID6.
> 
> What is silly on that? :-)

Because it is silly, RAID6 definition is DATA + 2 PARITY. So DATA can be
1 drive.

> IMHO if you need redundancy, you can simply use RAID1 on the three
> drives, and then you can add more drives to the array.

Yes. I can do 3 drive RAID1. I guess this is what I will have to do for
now.

> 
> I'm not sure what is your real intention here, why do you insist on
> RAID6, you said you'd like to add another drive maybe later to the
> array, but I'm not sure if RAID6 even supports adding new drives
> (while growing its size). As far as I tested, it reports error: mdadm:
> can only add devices to linear arrays (I assume RAID6 is not a linear
> array)

My real requirement is having 2 parity drives, so the array can survive
2 drive failure. This is why I insist on RAID6. On other systems I have
added drives to RAID5 and RAID6 without any problems, this is the beauty
of Linux RAID. Neil has done an incredible job with it.

As far as adding more drives, I have 5 drive hot swap bay currently, 2
drives are the old drives and 3 are new drives. I need to migrate to the
new drives before I add more drives. Also I don't have a 4th drive yet
and also I don't need the space yet.

> Tomas M
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


