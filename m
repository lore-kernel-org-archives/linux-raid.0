From: "Callahan, Tom" <CallahanT@tessco.com>
Subject: RE: First RAID Setup
Date: Thu, 15 Dec 2005 15:02:02 -0500
Message-ID: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Andargor The Wise' <andargor@yahoo.com>, "Callahan, Tom" <CallahanT@tessco.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I understand the reason for the RAID1 devices..... I was asking why you have
3 devices in the RAID1 setup? RAID1 is a mirrored configuration, requiring
only 2 disks for operation.

It is always wise to build in a spare however, that being said about all
raid levels. In your configuration, if a disk fails in your RAID5, your
array will go down. RAID5 is usually 3+ disks, with a mirror. So you should
have 3 disks at minimum, and then a 4th as a spare.

The MD modules/subsystem will then automagically bring in that spare disk if
any of the existing 3 in your RAID5 setup fail.

It is wise to think through your layout prior to building, and I commend you
for that. You may also want to review/experiment with the MD subsystem. For
instance, There is a neat --grow mode that is not mentioned in many vendor
man pages that can allow you to grow an MD device as needed.

Another gotcha, it's usually better to use entire disks, if you can afford
to, in an MD array. This alleviates growing pains of having to manually
repartition if you want to grow an exisiting filesystem. This may not make
much sense now, but once you have to do it, you'll smack your forehead in
grief.

Thanks,
Tom Callahan

-----Original Message-----
From: Andargor The Wise [mailto:andargor@yahoo.com]
Sent: Thursday, December 15, 2005 2:45 PM
To: Callahan, Tom; linux-raid@vger.kernel.org
Subject: RE: First RAID Setup


The RAID1 partitions are to make sure:

1) The machine is able to boot even if a disk is lost
(/boot).
2) The machine isn't brought down if a disk is lost
(swap)

I thought about a spare drive, but I don't need high
availability. I'm satisfied with being able to recover
my data.

Andargor


--- "Callahan, Tom" <CallahanT@tessco.com> wrote:

> You "should" have a designated spare for RAID-5.
> 
> Not sure why you have 3 disks for each RAID1, RAID1
> is mirror, and unless
> the third drive is a spare, it is not needed.
> 
> Thanks,
> Tom Callahan
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf
> Of Andargor The Wise
> Sent: Thursday, December 15, 2005 2:10 PM
> To: linux-raid@vger.kernel.org
> Subject: First RAID Setup
> 
> 
> I admit it. I'm a RAID virgin.
> 
> However, after a disastrous failure of the sole
> drive
> I wasn't backing up, I decided to go RAID-5 under
> Slack 10.2 (first time ever with RAID-5).
> 
> The config:
> 
> Asus P5GL-MX (ICH6) mobo w/1 GB RAM, 4 x SATA ports
> P4 3.0G/1M
> 3 x WD2000JS 200.0 GB SATA drives
> 
> First, a question: the BIOS on this machine seems to
> list the SATA ports as "third/fourth IDE
> master/slave". Further, the documentation seems to
> say
> that SATA 1/2 are "master" and SATA 3/4 are "slave"
> (black and red connectors, respectively).
> 
> My understanding is that SATA drives are each on
> separate buses. Is this because the BIOS offers a
> P-ATA emulation mode for SATA and it makes it
> "easier"
> to understand for novices to show them that way?
> 
> I ask because people have said that it is not a good
> idea to have both IDE masters and slaves on the same
> bus as part of a RAID-5 array. I know SATA is
> different, but will using three of the SATA ports on
> this mobo be OK?
> 
> Second, after reading the excellent advice in this
> list, I decided that booting from RAID-5 might not
> be
> a good idea. So this is what I've been thinking:
> 
> Each disk partitioned alike:
> 	1	30MB 
> 	2	8GB (to allow for memory upgrades later)
> 	5	rest_of_disk
> 
> mds:
> 	md0	raid1 sda1 sdb1 sdc1
> 	md1	raid1 sda2 sdb2 sdc2
> 	md2	raid5 sda5 sdb5 sdc5
> 
> 	md0	/boot
> 	md1	swap
> 	md2	/
> 
> Does this look OK? What should the stripe and chunk
> sizes be, considering I'll be going with reiserfs?
> Typical usage: development machine, some DB apps
> with
> medium load, read-only mostly, not many writes. Very
> few large files (such as multimedia).
> 
> Or should I set up separate RAID-5's for /usr and
> /var
> as well?
> 
> Lastly, can I install directly to this
> configuration,
> or should I install on a separate disk and move
> things
> into the array?
> 
> Andargor
> 
> 
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam
> protection around 
> http://mail.yahoo.com 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
