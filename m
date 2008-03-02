From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 13:23:32 +0100
Message-ID: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hi all!

I'm not doing this for the first time but there were a few interesting
/ worrying points during the setup process and I'd rather clear those
up now.

Hardware:
Tyan Thunder K8W (S2885)
Dual Opteron 254, 2GB (2x2x512MB) RAM, 2x Promise SATA II TX4, Adaptec 29160
4x WD RE2-GP 1TB on the Promise (for raid5)
1x Maxtor Atlas 15K II on the Adaptec (system disk)

OS:
Debian testing-amd64
linux-2.6.22-3
mke2fs 1.40.6
mdadm

I did a badblocks -v -s -t random -w on all future RAID disks in
parallel to test / burn-in.
Result: no bad blocks, decent speed (vmstat: 148MB/s total read,
220MB/s total write), BUT the following error (once):

ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata2.00: (port_status 0x20080000)
ata2.00: cmd 25/00:80:80:a1:55/00:00:3a:00:00/e0 tag 0 cdb 0x0 data 65536 in
         res 50/00:00:ff:a1:55/00:00:3a:00:00/e0 Emask 0x2 (HSM violation)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

All four disks were beyond the first (random write) phase, but that's
all I can say as I had it running overnight. The "HSM violation" error
is all over Google but I couldn't find anything conlusive (= that I
could understand).

Ignoring the error I went on to create the array:

[exact command unavailable, see below. RAID5, 4 disks, 1024K chunk
size, internal bitmap, V1 superblock]

Went fine, only mdadm segfaulted:

mdadm[3295]: segfault at 0000000000000000 rip 0000000000412d2c rsp
00007fff9f31b5d0 error 4

This did only show up in dmesg so I'm not sure exactly when. Either
right after the create or after a first attempt at a create where I
had used -N instead of --name, which it didn't like (error message).
Recreated the array, just to be sure (same command as above).

Tried creating a filesystem:

mke2fs -E stride=256 -j -L tb-storage -m1 -T largfile4 /dev/md0

That was glacially slow, "writing inode tables" went up about 3-4/sec
(22357 total). Since I had forgotten the crypto layer anyway I
CTRL-Ced that attempt and added it:

[exact command unavailable, see below. Used 2048 (512byte sectors) for
LUKS payload alignment, which should land on it chunk boundaries]

OK. Back to the fs again, same command, different device. Still
glacially slow (and still running), only now the whole box is at a
standstill, too. cat /proc/cpuinfo takes about 3 minutes (!) to
complete, I'm still waiting for top to launch (15min and counting).
I'll leave mke2fs running for now ...


So, is all this normal? What did I do wrong, what can I do better?


Cheers,

C.
