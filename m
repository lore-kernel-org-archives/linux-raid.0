From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: PDC 20276 RAID support in 2.4.18
Date: Fri, 26 Jul 2002 17:51:29 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020726174544.22189A-100000@Maggie.Linux-Consulting.com>
References: <3D412ED5.7000209@mvista.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D412ED5.7000209@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: arjanv@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya steve

how was the system tested ???

-- my simple raid-compatibility test is:
	( assuming raid1 or raid5 setup on ide disks )

- pull out /dev/hda
	- see if it boots

- pull out /dev/hdc  ( the other boot disk )
	- see if it boots

- plug a virgin ( unformatted/unpartitioned disk )
  into either /dev/hda or /dev/hdc
	- see if it boots and resyncs itself

if the system doesnt boot or doesnt resync ( all by itself )
than i'd see its a problem and need more fixing... and tweeking

- i disable all onboard ( motherboard/firmware based raid )

have fun
alvin

the pdc 202xx series chips are great for sw raid5...
( inexpensive, functional and works in the promise/maxtor pci cards )

On Fri, 26 Jul 2002, Steven Dake wrote:

> Arjan and others,
> 
> I have added support for the PDC 20276 used on Gigabyte GA-8IHXP (and 
> possibly other motherboards) to the ATARAID feature of the linux 2.4.18 
> kernel.  I have tested that the pdcraid.c code works with this device.
> 
> I suspect you can drive this patch into the mainline kernel, but if you 
> know of a better person, please advise.
> 
> Thanks!
> -steve
> 

