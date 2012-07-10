From: Alex <mysqlstudent@gmail.com>
Subject: Re: Possible data corruption after rebuild
Date: Tue, 10 Jul 2012 13:53:01 -0400
Message-ID: <CAB1R3sipyxthDSh2AMU6b4pYnG00satTXFqqHaLnvUw2msxcXg@mail.gmail.com>
References: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
	<20120709101624.3dc4cdab@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709101624.3dc4cdab@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>> I had a situation where after rebooting all three drives of a RAID5
>> array were marked as spares. I rebuild the array using "mdadm -C
>> /dev/md1 -e 1.1 --level 5 -n 3  --chunk 512 --assume-clean /dev/sda2
>> /dev/sdb2 /dev/sdc2" and mdstat showed it was again assembled. The
>> filesystem types on /dev/sdb were all "Linux" instead of "Linux raid
>> autodetect", so I changed them back.
>
> You've been bitten by http://neil.brown.name/blog/20120615073245

Ugh, that sucks. I actually performed much of what you described
before hearing from you, but didn't realize the device order was so
important and the kernel wouldn't be able to determine it on its own.

If it wasn't a production system that I had to get back online before
Monday morning, I would have been less hasty and waited a bit longer
for guidance.

> So md1 is all happy again is it?

I actually broke that array previously and turned sda1 into an ext4
because I couldn't get fc15 to properly boot from RAID1 with grub
reliably.

>> When I tried to fsck it to be sure it was intact, it prompted me that
>> there was a problem with the superblock, and I answered Yes to "Fix?".
>
> Always use "fsck -n" to check if something is intact!!

As I think I mentioned in my post, I had previously experienced
something similar to this, and you helped me through it, but it was
much easier situation. The filesystem was intact with only rebuilding
the array. This time, when the array was intact, I didn't know I had
any other option other than proceed with the fsck to attempt to fix
the filesystem anyway.

The last thing I thought was the issue was a kernel bug, and my
exhaustive googling still left me without anything useful.

> As fsck thought it recognised a filesystem it is very likely that the first
> device is correct, so just try swapping the other to and issuing a new
> --create command.  Then "fsck -n".

I still have an image of all three disks on three new identical disks.

I'm pretty sure I tried all permutations of the three devices, and
fsck complained on each of them. I'm pretty sure I screwed it up along
the way with fscking.

If I deleted the journal with fsck, and it started complaining about
the root inode missing, is there anything else that could possibly
recover the data, or is it surely gone now?

Thanks,
Alex
