From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: when is a disk "non-fresh"?
Date: Thu, 7 Feb 2008 23:16:20 +0100
Message-ID: <200802072316.20907.Dexter.Filmore@gmx.de>
References: <200802030354.33435.Dexter.Filmore@gmx.de> <200802042305.11860.Dexter.Filmore@gmx.de> <18343.50072.164266.861934@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18343.50072.164266.861934@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 05 February 2008 03:02:00 Neil Brown wrote:
> On Monday February 4, Dexter.Filmore@gmx.de wrote:
> > Seems the other topic wasn't quite clear...
>
> not necessarily.  sometimes it helps to repeat your question.  there
> is a lot of noise on the internet and somethings important things get
> missed... :-)
>
> > Occasionally a disk is kicked for being "non-fresh" - what does this mean
> > and what causes it?
>
> The 'event' count is too small.
> Every event that happens on an array causes the event count to be
> incremented.

An 'event' here is any atomic action? Like "write byte there" or "calc XOR"?


> If the event counts on different devices differ by more than 1, then
> the smaller number is 'non-fresh'.
>
> You need to look to the kernel logs of when the array was previously
> shut down to figure out why it is now non-fresh.

The kernel logs show absolutely nothing. Log's fine, next time I boot up, one 
disk is kicked, I got no clue why, badblocks is fine, smartctl is fine, selft 
test fine, dmesg and /var/log/messages show nothing apart from that news that 
the disk was kicked and mdadm -E doesn't say anything suspicious either.

Question: what events occured on the 3 other disks that didn't occur on the 
last? It only happens after reboots, not while the machine is up so the 
closest assumption is that the array is not properly shut down somehow during 
system shutdown - only I wouldn't know why.
Box is Slackware 11.0, 11 doesn't come with raid script of its own so I hacked 
them into the boot scripts myself and carefully watched that everything 
accessing the array is down before mdadm --stop --scan is issued.
No NFS, no Samba, no other funny daemons, disks are synced and so on.

I could write some failsafe inot it by checking if the event count is the same 
on all disks before --stop, but even if it wasn't, I really wouldn't know 
what to do about it.

(btw mdadm -E gives me:     Events : 0.1149316 - what's with the 0. ?)

Dex



-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
