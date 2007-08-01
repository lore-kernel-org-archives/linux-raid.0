From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Homehost suddenly changed on some components
Date: Wed, 01 Aug 2007 08:29:16 -0400
Message-ID: <46B07C9C.1010508@tmr.com>
References: <A2BCA40B-B212-4ECD-BEE1-29C50A7A13ED@lambdalifting.org> <B6D3B554-A931-4CA4-8779-E2F9510191AC@lambdalifting.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B6D3B554-A931-4CA4-8779-E2F9510191AC@lambdalifting.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Amanshauser <linux-raid@lambdalifting.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Amanshauser wrote:
> For the record:
>
> After reading in the archives about similar problems, which were 
> probably caused by something else but still close enough, I recreated 
> the array with the exact same parameters from the superblock and one 
> missing disk.
>
> > mdadm -C /dev/md0 -l 5 -n 10 -c 64 -p ls /dev/sdb1 /dev/sdd1 
> /dev/sde1 /dev/hde1 /dev/hdb1 /dev/hdf1 /dev/hdh1 /dev/hdg1 /dev/sdc1 
> missing
>
> Seems to have done the trick, fsck is working right now.
>
>
> Funny things seem to happen to the superblocks more often than I 
> thought. Recreating with one missing disk appears more like a hack 
> than a solution to me. Maybe mdadm should have some kind of explicit 
> superblock manipulation, like copying from other components or 
> importing/exporting from/to a file, so such problems can be solved in 
> a safe way?

I have a feeling that Neil added a UUID reset capability someplace, 
maybe grow, because I was having a similar problem. Data would be on 
another machine I can't check from here, but that's my recollection. 
Could be wrong, obviously.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

