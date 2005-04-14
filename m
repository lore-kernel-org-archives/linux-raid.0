From: David Greaves <david@dgreaves.com>
Subject: Re: Expanding array by changing disks (one by one)
Date: Thu, 14 Apr 2005 12:04:26 +0100
Message-ID: <425E4E3A.7070403@dgreaves.com>
References: <425E41C8.7050704@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <425E41C8.7050704@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CARON <lcaron@apartia.fr>
Cc: Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Laurent CARON wrote:

> Hello,
>
> We are in the process of increasing the size our RAID Arrays as our 
> storage needs increase.

Hi,
I'm no expert but I'll bounce some thoughts back at you...

>
> I've got 2 solutions for this:
>
> - Copy the data over a new array and replace the disks

pros:
sane and minimal risk of data loss since you don't delete data until the 
new one is up.
quickest solution (in manpower, elapsed time and system outages)

cons:
doesn't test Neils grow mode in mdadm (without which none of this would 
be possible)

> - Replace each disk (one after the other(after resync)) of the 
> existing array with a bigger one.

and the corollorary of sane would be... <joke>

>
> Start:
>    - Array is ok
> - Remove 1 disk
>    - Array is degraded
> - Add a bigger disk
>    - Resync
> - Remove another disk
>    - Array is degraded
> - Add a bigger disk
>    - Resync
> .....
>
This seems like it would work with mdadm's shiny new(?) grow command.
It looks from the man page like you use the grow command *after* 
changing out all the disks; yes?
Shiny and new means you need a reliable backup.
And this is likely to be slow - 1 resync per disk - and needs a system 
shutdown/outage for each disk swapped (assuming not hot-swap-able)
If you do have hot-swap then this seems like quite a nice option (no 
outages)

Mad speculative question ...
Would doing this work:
- add new big disk
- mdadm --remove a disk
- dd if=<removed disk> of=<new disk>
- mdadm -add new disk?
- remove small disk

if so it'd be a lot quicker than a resync each time...

> Would this be the 'state of the art' way ?

Have you seen EVMS? It has the ability to add devices to a raid5 array.
I'd class that as state of the art since you aren't 'throwing away' the 
smaller disks.

> Will the filesystem cope with it?

yes assuming it has a growfs.

>
> Is my mind completely broken?

not yet - let us know after you try it...

David
