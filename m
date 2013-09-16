From: Dave Gomboc <dave_gomboc@acm.org>
Subject: raid10 recovery assistance requested
Date: Sun, 15 Sep 2013 20:30:20 -0700
Message-ID: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Last night, I had booted using sysresccd-3.7.1 and been able to see
the contents of the raid10, with one problem (I believe /proc/mdstat
was showing a _ amongst the AAA).  However, I was able to mount the md
device, and lvm commands were finding data just fine.  I even mounted
a logical volume that normally mounts to /srv -- it had not been
checked for a long time so it automatically did an fsck.  (I was not
thrilled about this, but I wasn't positive I should interrupt it
either.)  The fsck appeared to succesfully complete: at least, no
error was reported amongst the 5 steps by the time I got out of bed
this morning.  Without intending to change anything related to the
raid setup, it appears that I somehow did so while using
sysresccd-3.7.1 when booting the machine again this morning, because I
am now unable to mount the raid10.

I have run mdadm --examine --scan 2>&1 | less (though I am typing this
by hand from another computer off of a written copy of data that was
on-screen earlier today).

No md superblock detected on /dev/sdl, /dev/sdk, /dev/sdj, /dev/sdi,
/dev/sda3, /dev/sda2, /dev/sda1, /dev/sda, /dev/sr0, /dev/loop0.  No
surprises there.

Specific fields that were different between the four devices, I list
after this paragraph.  For each of /dev/sdi1, /dev/sdj1, /dev/sdk1,
and /dev/sdl1, the following fields were identical: magic (a92b4efc),
version (1.2), feature map (0x0), array uuid (3c76...), name
(cheap:teramooch), creation time, raid level (raid10), raid devices
(4), avail dev size: 3907021954 (1863.01 GiB 2000.40 GB), array size:
7814041600 (3726.03 GiB 4000.79 GB), used dev size: 3907020800
(1863.01 GiB, 2000.39 GB), data offset (2048 sectors), super offset (8
sectors), state (clean), layout (near=2), chunk size(512K)

Two of the four drives have in addition to the above the following,
identical information:
device uuid: 6680...
update time: Sat Sep 14 06:14:13 2013
checksum: 6b7397f - correct [yes, only 7 hex digits]
events: 520
device role: Active device 0
array state: AAAA

The other two drives have identical alternative information:
device uuid: 45ff...
update time: Sun Sep 15 09:54:22 2013
checksum: 1cbfeaea - correct
events: 599
device role: Active device 3
array state: .AAA

I do also have the four drive serial numbers (from ls -l
/dev/disk/by-id), and have figured out which pair are "active device
0" versus "active device 3" (though I cannot currently distinguish
between the two drives that report identical data).  I had also been
seeing something like "inactive" with two (S) when catting
/proc/mdstat, but unfortunately I did not record the precise text that
was given.

Subsequent to performing the above, I have invoked mdadm --stop, used
smartctl (which appears to report that all of the drives are actually
working, though "old age" is listed in a few categories) and the
machine has since been powered down again.

I hope (and suspect) that some variation of --build (or perhaps even
--assemble) involving --assume-clean might restore access to my data,
but I figured that it would be prudent to ask here before I fscked
anything up further.  I have four larger (GPT) drives ready to migrate
all of the data to, so if I could make the raid10 available again,
then I am ready to migrate the data off without any further reboots.

Your help is appreciated,
Dave
