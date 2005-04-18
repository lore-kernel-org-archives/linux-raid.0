From: David Greaves <david@dgreaves.com>
Subject: Re: Questions about software RAID
Date: Mon, 18 Apr 2005 21:12:21 +0100
Message-ID: <426414A5.3020706@dgreaves.com>
References: <1113853825.1483.34.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1113853825.1483.34.camel@debian>
Sender: linux-raid-owner@vger.kernel.org
To: tmp <skrald@amossen.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tmp wrote:

>I read the software RAID-HOWTO, but the below 6 questions is still
>unclear. I have asked around on IRC-channels and it seems that I am not
>the only one being confused. Maybe the HOWTO could be updated to
>clearify the below items?
>
>
>1) I have a RAID-1 setup with one spare disk. A disk crashes and the
>spare disk takes over. Now, when the crashed disk is replaced with a new
>one, what is then happening with the role of the spare disk?
>
the new disk is spare, the array doesn't revert to it's original state.

> Is it
>reverting to its old role as spare disk?
>  
>
so no it doesn't.

>If it is NOT reverting to it's old role, then the raidtab file will
>suddenly be out-of-sync with reality. Is that correct?
>  
>
yes
raidtab is deprecated - man mdadm

>Does the answer given here differ in e.g. RAID-5 setups?
>  
>
no

>
>2) The new disk has to be manually partitioned before beeing used in the
>array.
>
no it doesn't. You could use the whole disk (/dev/hdb).
In general, AFAIK, partitions are better as they allow automatic 
assembly at boot.

> What happens if the new partitions are larger than other
>partitions used in the array?
>
nothing special - eventually, if you replace all the partitions with 
bigger ones you can 'grow' the array

> What happens if they are smaller?
>  
>
it won't work (doh!)

>
>3) Must all partition types be 0xFD? What happens if they are not?
>  
>
no
They won't be autodetected by the _kernel_

>
>4) I guess the partitions itself doesn't have to be formated as the
>filesystem is on the RAID-level. Is that correct?
>  
>
compulsory!

>
>5) Removing a disk requires that I do a "mdadm -r" on all the partitions
>that is involved in a RAID array. I attempt to by a hot-swap capable
>controler, so what happens if I just pull out the disk without this
>manual removal command?
>  
>
as far as md is concerned the disk disappeared.
I _think_ this is just like mdadm -r.

>Aren't there some more hotswap-friendly setup?
>  
>
What's unfriendly?

>
>6) I know that the kernel does stripping automatically if more
>partitions are given as swap partitions in /etc/fstab. But can it also
>handle if one disk crashes?
>
no - striping <> mirroring
The kernel will fail to read data on the crashed disk - game over.

> I.e. do I have to let my swap disk be a
>RAID-setup too if I wan't it to continue upon disk crash?
>  
>
yes - a mirror, not a stripe.


David

