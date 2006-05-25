From: Craig Hollabaugh <craig@hollabaugh.com>
Subject: Re: RAID5 kicks non-fresh drives
Date: Thu, 25 May 2006 15:39:05 -0600
Message-ID: <1148593145.4704.6.camel@hendrix.hollabaugh.com>
References: <1148571503.2772.35.camel@hendrix.hollabaugh.com>
	 <17526.7947.129968.287311@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17526.7947.129968.287311@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

sdj and sdk are FS Type 'Linux'.
all the other partitions are FS Type 'Linux raid autodetect'

I don't remember ever having to set the partition type. It's not in my
build notes for this machine or another 13 drive server. 

Should I change partition type to 'Linux raid autodetect'? 

If so, how can I verify array configuration prior to rebooting? 

Thanks for the reply Neil. I never checked that.
Craig
ps. My new drives are certainly getting a workout through this learning
process. 




On Fri, 2006-05-26 at 07:18 +1000, Neil Brown wrote:
> On Thursday May 25, craig@hollabaugh.com wrote:
> > 
> > >From dmesg
> > md: Autodetecting RAID arrays.
> > md: autorun ...
> > md: considering sdl1 ...
> > md:  adding sdl1 ...
> > md:  adding sdi1 ...
> > md:  adding sdh1 ...
> > md:  adding sdg1 ...
> > md:  adding sdf1 ...
> > md:  adding sde1 ...
> > md:  adding sdd1 ...
> > md:  adding sdc1 ...
> > md:  adding sdb1 ...
> > md:  adding sda1 ...
> > md:  adding hdc1 ...
> > md: created md0
> > 
> > The kernel didn't add sdj or sdk.
> > 
> 
> And the partition types of sdj1 and sdk1 are ???
> 
> NeilBrown
> 
-- 
------------------------------------------------------------
Dr. Craig Hollabaugh, craig@hollabaugh.com, 970 240 0509
Author of Embedded Linux: Hardware, Software and Interfacing
www.embeddedlinuxinterfacing.com

