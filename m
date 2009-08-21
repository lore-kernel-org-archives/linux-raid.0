From: "NeilBrown" <neilb@suse.de>
Subject: Re: a problem with mdadm 2.6.9
Date: Fri, 21 Aug 2009 12:23:10 +1000 (EST)
Message-ID: <d3efa87188ee29c0b3347459276f4faf.squirrel@neil.brown.name>
References: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeffunit <jeff@jeffunit.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, August 21, 2009 12:01 pm, jeffunit wrote:
> I had a computer that was running mdadm with no problems.
> Then the motherboard failed, while the array was in the process of
> rebuilding.
> I replaced the motherboard with a new motherboard,
> and I an trying to rebuild my raid array.
>
> I am running mandriva 2009.1 spring (the latest). The kernel is 2.6.29.6
> I have a 7 drive raid 5 array.
> I said
> mdadm --assemble /dev/md0 /dev/sd[bcdefgh]
>
> I got the error
> mdadm cannot open device: /dev/sdb device or resouce busy
> mdadm device /dev/md0 has no superblock - assembly aborted
>
> I then tried to make a degraded array
> mdadm --assemble /dev/sd[cdefgh] --force
> That seemed to work, and the array was degraded.
>
> I decided to reboot to see if I could get /dev/sdb online.
> I did, and it didn't help.
>
> What can I do to recover my array?


You need to find out why sdb is busy.
Maybe look in /sys/block/sdb/holders.
Maybe some filesystem on it go automagically mounted by mistake
or something.
Maybe send:
  cat /proc/mounts /proc/swaps /proc/mdstat /proc/partitions
  find -H /sys/block/sdb -ls

and we can see if there are any hints.
Maybe send full kernel logs from the boot sequence as well.

NeilBrown


