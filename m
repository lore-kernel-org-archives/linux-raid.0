From: Gordon Henderson <gordon@drogon.net>
Subject: Re: looking for cheap(er) RAID
Date: Sat, 20 Sep 2003 09:34:01 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0309200923570.590@unicorn.drogon.net>
References: <no.Yo.20700.N.nN.0309191740020@business.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <no.Yo.20700.N.nN.0309191740020@business.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 19 Sep 2003 linux-raid@ied.com wrote:

>
>  Hi guys,
>
>   I've spent on this at least 2hrs now and still am w/out a
> clue.
>
>   I could get a HPT372-based HW RAID, but found a lot of
> reports on the net of haslles associated. Looked into
> TX2000, but found not positive reports on the net. (I am
> planning to install Mandrake 9.1 on a server.)
>
>   I searched wide and deep on google "linux recommended
> raid", but nothing reasonably current turned up.
>
>   FAQ at http://linas.org/linux/raid.html covers no uptodate
> recommendation for linux RAID hw.
>
>   Could someone please tell me (a FAQ) of a cheap(er) RAID,
> where I could install out-of-the-box Mandrake 9.1 ? (I would
> like the boot & root fs to be on the RAID as well.) BTW, I
> have IDE drives, not SCSI drives.
>
>   My HW is Intel P42.4 533FSB (RB) CPU, ASUS P4BGLMX-533.
>
>   How much slower would it be with software RAID ? Could we
> have boot & root on software raid (for now just two disks
> mirrorred). I imagine boot wouldn't care, since it is just
> mirrored. But would MDK installation work ? Or should I just
> dd if=/dev/hda1 of=/dev/hdc1 ; mount -o remount /dev/md... /
> after installation ?

I doubt you'd notice any speed difference with software RAID and hardware
for RAID1. (But I've no recent experience with hardware controllers) One
advantage you might get with s/w raid is that you have he potential to
access 2 physical devices at the same time, but I'm not sure if this makes
much of a difference with IDE dirves and RAID1, even if they are on
different controllers. In any case it won't be any slower than a single
drive.

I have lots of servers which boot of RAID1 - off HDA and HDC as masters on
the 2 on-board controllers. However, I use Debian and roll my own as it
doesn't support an install directly onto RAID. I've no idea how Mandrake
does it - it's certianly possible to do an install on a single drive, then
migrate all the partitions over to RAID1 (This is how I do it, using the
swap partition temporarrily to shuffle data about, after I have a minimal
instllation that'll let me re-compile the kernel) The S/W RAID How-To has
a good section on booting from RAID and its technique for turning the root
partition from a single disk into RAID1 is what I use for all partitions.
I know RH supports install directly onto RAID though, maybe Mandrake does
also.

Read the HowTo at
  http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html

Your hardware is fine, just get 2 identical disks and make them masters,
one on each controller. Make sure the BIOS can boot off the 2nd
controller, should the first drive fail, but my experience with ASUS
boards has been good in this respect for a long time.

Good luck!

Gordon
