From: Neil Brown <neilb@suse.de>
Subject: Re: striping of a 4 drive raid10
Date: Mon, 28 Jan 2008 07:20:27 +1100
Message-ID: <18332.59275.701583.679244@notabene.brown>
References: <20080127193345.GA5426@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Sunday January 27
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 27, keld@dkuug.dk wrote:
> Hi
> 
> I have tried to make a striping raid out of my new 4 x 1 TB
> SATA-2 disks. I tried raid10,f2 in several ways:
> 
> 1: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, md2 = raid0
> of md0+md1
> 
> 2: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, md2 = raid01,f2
> of md0+md1
> 
> 3: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, chunksize of 
> md0 =md1 =128 KB,  md2 = raid0 of md0+md1 chunksize = 256 KB
> 
> 4: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, chunksize
> of md0 = md1 = 128 KB, md2 = raid01,f2 of md0+md1 chunksize = 256 KB
> 
> 5: md0= raid10,f4 of sda1+sdb1+sdc1+sdd1

Try
  6: md0 = raid10,f2 of sda1+sdb1+sdc1+sdd1

Also try raid10,o2 with a largeish chunksize (256KB is probably big
enough).

NeilBrown


> 
> My new disks give a transfer rate of about 80 MB/s, so I expected
> to have something like 320 MB/s for the whole raid, but I did not get
> more than about 180 MB/s.
> 
> I think it may be something with the layout, that in effect 
> the drives should be something like:
> 
>           sda1             sdb1    sdc1      sdd1
>            0                1       2         3
>            4                5       6         7
> 
> And this was not really doable for the combination of raids,
> because thet combinations give different block layouts.
> 
> How can it be done? Do we need a new raid type?
> 
> Best regards
> keld
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
