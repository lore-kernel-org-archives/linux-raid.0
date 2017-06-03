From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Sun, 4 Jun 2017 01:29:19 +0200
Message-ID: <20170603232919.GA17108@metamorpher.de>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Tonelli <paul@tonel.li>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 04, 2017 at 12:33:43AM +0200, Paul Tonelli wrote:
> I am still searching for a way to put a complete block device (/dev/sdX) 
> read-only for these tests, I believe using overlays is the solution.

Yes.

Overlays are extremely useful for data recovery.

It is unfortunate there is no standard tool to manage them easily.
The "overlay functions" in the wiki come close but people don't find 
out about it until it's too late.

> Actually, this is one question I have: with mdadm, creating a raid5 with 
> two disks and then growing it to 3 creates exactly the same structure as 
> creating directly a 3 disk raid5 ? Your message seems to say it is the 
> same thing.

Good catch. It would probably move the data offset.

# truncate -s 3TB a b c
# mdadm --create /dev/md42 --level=5 --raid-devices=2 /dev/loop[01]
# mdadm --examine /dev/loop0
    Data Offset : 262144 sectors
# mdadm --grow /dev/md42 --raid-devices=3 --add /dev/loop2
# mdadm --examine /dev/loop0
    Data Offset : 262144 sectors
     New Offset : 260096 sectors

So on re-create you have to find and specify the correct --data-offset.

How to determine the correct data offset? See if you can find LVM magic 
string "LABELONE" in the first 256MiB of the two disks you didn't 
dd-overwrite. That minus 512 bytes should be the correct offset.

# hexdump -C /dev/some-pv
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200  4c 41 42 45 4c 4f 4e 45  01 00 00 00 00 00 00 00  |LABELONE........|
00000210  55 87 20 ff 20 00 00 00  4c 56 4d 32 20 30 30 31  |U. . ...LVM2 001|

If unlucky it just happened to be in the drive you overwrite. 
In that case you have to xor the two others.

> Is it possible to copy only a raid superblock from one disk to another 
> directly using dd ?

Each superblock is unique (differs in device role and checksum at minimum). 
So copying superblocks usually is not a thing. Even copying drives can 
result in a mess (UUIDs are no longer unique, you have little / no control 
which drive will actually be used). This is also a problem you might 
encounter with overlays in conjunction with autoassembly/automount magicks 
that might be running in the background.

Regards
Andreas Klauer
