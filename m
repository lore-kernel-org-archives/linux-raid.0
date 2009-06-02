From: Alexander Rietsch <Alexander.Rietsch@hispeed.ch>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Tue, 2 Jun 2009 14:00:15 +0200
Message-ID: <C840D176-51A0-4AFD-8AD0-1F1D2CAA830D@hispeed.ch>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> AFAIK, the only solution at this stage is to recreate the array.
>
> You need to use the "--assume-clean" flag (or replace one of the  
> drives
> with "missing"), along with _exactly_ the same parameters & drive  
> order
> as when you originally created the array (you should be able to get  
> most
> of this from mdadm -D).  This will rewrite the RAID metadata, but  
> leave
> the filesystem untouched.

A glimpse of hope. Thank you! Didn't know about this --assume-clean  
flag. So just to double-check:

The array to create would be:
disc 0: sdi1 <- is now disc 7 and SPARE due to failed replacement  
operation
disc 1: sdl1
disc 2: sdh1
disc 3: sdj1
disc 4: sdk1
disc 5: sdg1
disc 6: sda1 <- is now faulty removed

So I just create an incomplete array without sda1 in the same order  
which would be:

mdadm --create /dev/md0 --assume-clean --level=5 --chunk=64 --raid- 
devices=7 /dev/sdi1 /dev/sdl1 /dev/sdh1 /dev/sdj1 /dev/sdk1 /dev/sdg1

I'm not sure about the drive oder in the mdadm command: is it correct  
to assume <drive 0> <drive 1> <drive 2> in order or is it mirrored  
like <drive 2> <drive 1> <drive 0> ?
I also hope the command doesn't trigger any recovery actions or  
filesystem changes..
