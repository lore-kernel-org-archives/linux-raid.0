From: <senthilkumar.muthukalai@wipro.com>
Subject: RE: Growing Linear RAID
Date: Thu, 10 Dec 2009 13:54:29 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02C8C165@BLR-EC-MBX03.wipro.com>
References: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com> <20091210123353.66100b41@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091210123353.66100b41@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I get only the following message under /var/log/

[root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow --add /dev/sata3 
mdadm: Cannot add new disk to this array

Dec  9 20:37:58 NAS00226b1755a0 kernel: md: export_rdev(sdc)

[root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow --add /dev/sata4
mdadm: Cannot add new disk to this array

Dec  9 20:38:30 NAS00226b1755a0 kernel: md: export_rdev(sdd)

Thanks,
Senthil M

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, December 10, 2009 7:04 AM
To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
Cc: linux-raid@vger.kernel.org
Subject: Re: Growing Linear RAID

On Wed, 9 Dec 2009 20:31:54 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> Hi,
> 
> I am trying to add a disk to a Linear Raid which was created with 2
> disks.
> We use linux-2.6.18 and mdadm-2.6.4.
> I guess these support the above mentioned disk addition.

Yes, should work.  This functionality was introduced in 
2.6.18.


> root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow --add /dev/sata3  

This is the correct usage but,
   
> mdadm: Cannot add new disk to this array

This indicates that something went wrong.

Do you get any messages in the kernel logs at this point?

NeilBrown
