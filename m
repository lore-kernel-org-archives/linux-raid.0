From: Aaron Scheiner <blue@aquarat.za.net>
Subject: Grub-install, superblock corrupted/erased and other animals
Date: Wed, 27 Jul 2011 14:16:52 +0200
Message-ID: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

My original message was sent (and rejected) 4 days ago because it was
in HTML (whoops). Here's my original e-mail with updates :

I've got an Ubuntu machine with an mdadm RAID array on level 6.=A0The
RAID-6 array consists of 10 drives and has been running for about 3
years now. I recently upgraded the drives in the array from 1TB units
to 2TB units.

The drive on which the OS sat died a few days ago, so I installed a
new OS drive and then installed Ubuntu Server on it.
On reboot the machine hung on a black screen with a white flashing
cursor. So I went back into the Ubuntu Setup and installed grub to all
of the drives in the raid array (except two) [wow, this was such a
stupid move].

I then rebooted the machine and it successfully booted into Ubuntu
Server. I set about restoring the configuration for the raid array...
only to be given the message "No Superblock Found" (more or less).
Each element in the array was used directly by mdadm (so /dev/sda, not
/dev/sda1).

I see that the superblock is stored within the MBR region on the drive
(which is 512bytes from the start of the disk), which would explain
why the superblocks were destroyed. I haven't been able to find
anything regarding a backup superblock (does something like this
exist?).

I have now started using a script that tries to re-create the array by
running through the various permutations available... it takes roughly
2.5 seconds per permutation/iteration and there are just over 40 000
possibilities. The script tests for a valid array by trying to mount
the array as read only (it's an XFS file system). I somehow doubt that
it will mount even when the correct combination of disks is found.
[UPDATE] : It never mounted.

So... I have an idea... The array has a hole bunch of movie files on
it and I have exact copies of some of them on another raid array. So I
was thinking that if I searched for the start of one of those files on
the scrambled array, I could work out the order of the disks by
searching forward until I found a change. I could then compare the
changed area (probably 128KB/the chunk size forward) with the file I
have and see where that chunk lies in the file, thereby working out
the order.
[UPDATE] : Seeing as the array never mounted, I have proceeded with
this idea. I took samples of the start of the video file and provided
them to Scalpel as needles for recovery. After two days of searching,
Scalpel located the starts of the various segments in the raid array
(I re-created the raid array with the drives in random order). I then
carved (using dd) 3MBs out of the raid array that contains all the
samples handed to scalpel originally (plus a bit more).

So now I have to find segments of the start of the intact file in the
carved out data from the raid array.

It would be really useful if I knew the layout of the array :

If the chunk size of the array is 128KB, does that mean that the file
I carved will be divided up into segments of contiguous data, each
128KBs in length ? or does it mean that the length of contiguous data
will be 16KB ( 128 KB / 8 drives ) ?

Do these segments follow on from each other without interruption or is
there some other data in-between (like metadata? I'm not sure where
that resides).

Any explanation of the structure of a raid6 array would be greatly
appreciated, as well as any other advice (tools, tips, etc).

Thanks :)

Aaron (24)
South Africa
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
