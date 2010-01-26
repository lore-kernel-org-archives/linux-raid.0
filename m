From: Asdo <asdo@shiftmail.org>
Subject: Re: Several steps to death
Date: Tue, 26 Jan 2010 10:28:29 +0100
Message-ID: <4B5EB5BD.7070406@shiftmail.org>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

aragonx@dcsnow.com wrote:
> If I try to mount it now, with the correct configuration I get the
> following error:
>
> mdadm --create /dev/md0 --level=5 --spare-devices=0 --raid-devices=5
> /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
>
> ...
>   

I think this is the point where you destroyed your data. Probably the 
devices were not specified in the exact order as before: in this command 
you specified the array with increasing letters order but if you changed 
the mainboard, drives won't be detected in the same order as with the 
old mainboard.

Previously when you thought it was detected as 4 disks + 1 spare, I 
believe instead it was just doing a resync because the array was stale, 
probably the old mainboard broke when it was writing something. Hadn't 
you entered the above --create command, your data would presumably still 
be there. You didn't try mounting it, did you?

At the current state of things, I'm not sure if you can get your data 
out of there.

In theory if you stop the current resync, try to recreate it in all 
possible permutations of 5 drives using --assume-clean during creation 
so to prevent any resyncs (and just mount readonly!) then try mounting 
it or try fsck -n to see if data makes sense, you might be able to get 
data out of it. I have never tried this technique, I read it from a post 
by Neil Brown in this ML, date 12/04/2009 10:12 PM, subject "Re: RAID5 
demise or coma? after re-creating with a spare" try looking for it in 
the archives
