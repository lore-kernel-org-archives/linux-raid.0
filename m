From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: partitioned raid issues
Date: Tue, 17 Feb 2009 00:51:05 +0100
Message-ID: <1234828265.21875.74.camel@poledra.romunt.nl>
References: <1234731603.21875.39.camel@poledra.romunt.nl>
	 <54e2612fae2bceefe16232bb6e557a3c.squirrel@neil.brown.name>
	 <1234742891.21875.51.camel@poledra.romunt.nl>
	 <2a82d263d2f4ece95b69a85bbebe4896.squirrel@neil.brown.name>
	 <1234771658.21875.53.camel@poledra.romunt.nl>
	 <18841.51060.218570.36811@notabene.brown>
	 <1234817646.21875.67.camel@poledra.romunt.nl>
	 <973caa1ee57b05b881a459328ff1262f.squirrel@neil.brown.name>
Reply-To: Rudy@grumpydevil.homelinux.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <973caa1ee57b05b881a459328ff1262f.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Op dinsdag 17-02-2009 om 08:20 uur [tijdzone +1100], schreef NeilBrown:

> Here is that patch against 2.6.28
> 
> NeilBrown
> 
> iff --git a/block/genhd.c b/block/genhd.c
> index 2f7feda..c7ad108 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1072,6 +1072,14 @@ dev_t blk_lookup_devt(const char *name, int partno)
>  		if (strcmp(dev->bus_id, name))
>  			continue;
> 
> +		if (partno < disk->minors) {
> +			/* We need to return the right devno, even
> +			 * if the partition doesn't exist yet.
> +			 */
> +			devt = MKDEV(MAJOR(dev->devt),
> +				     MINOR(dev->devt) + partno);
> +			break;
> +		}
>  		part = disk_get_part(disk, partno);
>  		if (part) {
>  			devt = part_devt(part);
> 


And the results are:
BIOS EBDA/lowmem at: 0009d000/0009cc00
Linux version 2.6.28.2 (root@astra) (gcc version 3.4.6) #4 SMP Mon Feb
16 22:40:39 CET 2009
KERNEL supported cpus:

<snip>


md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md_d0 active with 2 out of 2 mirrors
md: ... autorun DONE.
md_d0: p1 p2 p3 p4 < p5 p6 p7 >
ReiserFS: md_d0p1: found reiserfs format "3.6" with standard journal
ReiserFS: md_d0p1: using ordered data mode
ReiserFS: md_d0p1: journal params: device md_d0p1, size 8192, journal
first block 18, max trans len 1024, max batch 900, max commit age 30,
max trans age 30
ReiserFS: md_d0p1: checking transaction log (md_d0p1)
ReiserFS: md_d0p1: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 304k freed


So the patch works :)

I suggest it is taken along in 2.6.28.6 and 2.6.29

Cheers,

Rudy

