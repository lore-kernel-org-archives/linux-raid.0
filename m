From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: RAID1 VS RAID5
Date: Sun, 26 Oct 2003 18:55:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031026165537.GW26480@mea-ext.zmailer.org>
References: <1067179519.1222.107.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1067179519.1222.107.camel@cala>
To: Mario Giammarco <mgiammarco@virgilio.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 26, 2003 at 03:45:19PM +0100, Mario Giammarco wrote:
> Hello,
> I would like to buy new SCSI hard disk to be used with lsi 160
> controller in 32 bit pci.
> 
> I can choose:
> 
> - RAID5 of three Maxtor Atlas 10K II 9gb
> - RAID1 of two   Maxtro Atlas 10K III 18gb
> 
> My problem is: I have seen that RAID1 code does not interleave reads so
> it does not improve performance very much putting two hard disks.

 Performance boosting isn't primary goal in RAID schemes involving
 data replication.

 For RAID1 a suitably chosen read-interleave could be used to improve
 _large_ file reads, of course.  Another strategy is to distribute read
 operations to all online disks forming up the RAID1 set with elevators
 of their own.

> Is there a patch to change raid1 behaviour?

 If it feels important, such can be made.

> In linux 2.6.0 is it better?

 It can be made, if it isn't.

> Thanks in advance for any reply.
> -- 
> Mario Giammarco

/Matti Aarnio
