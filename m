From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: striping of a 4 drive raid10
Date: Mon, 28 Jan 2008 20:03:52 +0100
Message-ID: <20080128190352.GA30891@rap.rap.dk>
References: <20080127193345.GA5426@rap.rap.dk> <18332.59275.701583.679244@notabene.brown> <479E1FD0.4000702@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479E1FD0.4000702@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 28, 2008 at 01:32:48PM -0500, Bill Davidsen wrote:
> Neil Brown wrote:
> >On Sunday January 27, keld@dkuug.dk wrote:
> >  
> >>Hi
> >>
> >>I have tried to make a striping raid out of my new 4 x 1 TB
> >>SATA-2 disks. I tried raid10,f2 in several ways:
> >>
> >>1: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, md2 = raid0
> >>of md0+md1
> >>
> >>2: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, md2 = raid01,f2
> >>of md0+md1
> >>
> >>3: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, chunksize 
> >>of md0 =md1 =128 KB,  md2 = raid0 of md0+md1 chunksize = 256 KB
> >>
> >>4: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, chunksize
> >>of md0 = md1 = 128 KB, md2 = raid01,f2 of md0+md1 chunksize = 256 KB
> >>
> >>5: md0= raid10,f4 of sda1+sdb1+sdc1+sdd1
> >>    
> >
> >Try
> >  6: md0 = raid10,f2 of sda1+sdb1+sdc1+sdd1
> >
> >Also try raid10,o2 with a largeish chunksize (256KB is probably big
> >enough).
> >  
> 
> Looking at the issues raised, there might be some benefit from having 
> the mirror chunks on the slower inner tracks of a raid10, and to read 
> from the outer tracks if the drives with the data on the outer tracks 
> are idle. This would appear to offer a transfer rate benefit overall.

Hmm, how do I do this? I think this is normal behaviour of a raid10,f2.
Is that so?

So you mean I should rather use f2 than o2? Or should I configure the f2
in some way?

My hdparm -t gives:

/dev/sda5:
 Timing buffered beginning disk reads:   82 MB in  1.00 seconds = 81.686 MB/sec
 Timing buffered ending    disk reads:   42 MB in  1.03 seconds = 40.625 MB/sec
 Average seek time 13.714 msec, min=4.641, max=23.921
 Average track-to-track time 28.151 msec, min=26.729, max=28.730

So, yes, there is a reason to use the faster outer tracks - and have the 
faster access time that f2 gives . How does o2 behave here? Does it read
and search on the whole disk?


As to your other comments in another mail, I could of cause install
a newer kernel and mdadm, but then I would loose the support of my
supported and paid system. And Neil said that there have been no
performance fixes for f2 since the kernel I use (2.6.12).
I thought that o2 support was included since 2.6.10 - but apparantly not
so. 

Best regards
keld
