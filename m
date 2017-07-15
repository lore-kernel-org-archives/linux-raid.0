From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Superblocks lost on all disks in array.
Date: Sat, 15 Jul 2017 19:26:43 +0200
Message-ID: <20170715172643.GA24000@metamorpher.de>
References: <CAH_1ubwzXd9C8OBheZv+Z5oFTVt2rG+RATHrhKy6uiVv84y_SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH_1ubwzXd9C8OBheZv+Z5oFTVt2rG+RATHrhKy6uiVv84y_SA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Pierre Human <jphuman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 15, 2017 at 07:09:08PM +0200, Jean-Pierre Human wrote:
> The array was setup with the below commands:
> #mdadm --create --verbose /dev/md2 --level=10 --raid-devices=4
> /dev/sdj /dev/sdk /dev/sdl /dev/sdi

So you didn't use a partition table?

> root@store02:~# mdadm --examine /dev/sd[iklj]
> /dev/sdi:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> /dev/sdj:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> /dev/sdk:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> /dev/sdl:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)

And then "something" created one. Is that partition table empty? 
Or did it also create and format partitions, that would be worse.

GPT partition table overwrites a bunch of sectors at both start and end. 
So that's where you'll find corruption, depending which mdadm metadata 
version you were using (which can also be located either start or end).

To recover, you'll have to determine the correct RAID level / layout / 
order / data offset. It's best to do this with overlays 

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

and only write to the real disks once you've found the setting that works.

In the future, consider always using a partition table. Linux doesn't care *
but the partition table is the most standard way to declare a disk is 
already in use and for what. Without a partition table, any software not 
md-raid aware will see your drive as free, unused, and might format it.

(*) it will happily run anything you like on bare disks
    but it won't do anything to protect you, either

Regards
Andreas Klauer
