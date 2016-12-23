From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Fri, 23 Dec 2016 22:14:56 +0100
Message-ID: <CAOxFTcwaDfK+gKX2d4L4DuX=pf273M8qKGGOo8G+iAVSxurHhA@mail.gmail.com>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
 <22600.7486.444800.536687@quad.stoffel.home> <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com>
 <22601.44638.79418.124438@quad.stoffel.home> <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com>
 <87k2arpmvt.fsf@notabene.neil.brown.name> <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 23, 2016 at 5:17 PM, Giuseppe Bilotta
<giuseppe.bilotta@gmail.com> wrote:
>
> Now I wonder if it it would be possible to combine this approach with
> something that simply hacked the metadata of each disk to re-establish
> the correct disk order to make it possible to reassemble this
> particular array without recreating anything. Are problems such as
> mine common enough to warrant support for this kind of verified
> reassembly from assumed-clean disks easier?.

Actually, now that the correct order is verified, I would like to know
why re-creating the array using mdadm -C --assume-clean with the disks
in the correct order works (the RAID is then accessible, and I can
read data off of it).

However, if I  simply hand-edit the metadata to assign the correct
device order to the disks (I do this by restoring the correct device
roles in the dev_roles table, at the entries corresponding to the
disks' dev_numbers, in the correct order, and then adjust the checksum
accrdingly) and then assemble the array, I get I/O errors accessing
the array contents, even though raid6check doesn't report issues.

In the 'hacked dev role' case, the dmesg reads:

[  +0.002057] md: bind<dm-2>
[  +0.000936] md: bind<dm-1>
[  +0.000932] md: bind<dm-0>
[  +0.000925] md: bind<dm-3>
[  +0.001443] md/raid:md112: device dm-3 operational as raid disk 0
[  +0.000540] md/raid:md112: device dm-0 operational as raid disk 3
[  +0.000710] md/raid:md112: device dm-1 operational as raid disk 2
[  +0.000508] md/raid:md112: device dm-2 operational as raid disk 1
[  +0.009716] md/raid:md112: allocated 4374kB
[  +0.000555] md/raid:md112: raid level 6 active with 4 out of 4
devices, algorithm 2
[  +0.000531] RAID conf printout:
[  +0.000001]  --- level:6 rd:4 wd:4
[  +0.000001]  disk 0, o:1, dev:dm-3
[  +0.000001]  disk 1, o:1, dev:dm-2
[  +0.000000]  disk 2, o:1, dev:dm-1
[  +0.000001]  disk 3, o:1, dev:dm-0
[  +0.000449] created bitmap (22 pages) for device md112
[  +0.001865] md112: bitmap initialized from disk: read 2 pages, set 5
of 44711 bits
[  +0.533458] md112: detected capacity change from 0 to 6000916561920
[  +0.004194] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.003450] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001953] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001978] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001852] ldm_validate_partition_table(): Disk read failed.
[  +0.001889] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001875] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001834] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001596] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001551] Dev md112: unable to read RDB block 0
[  +0.001293] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001284] Buffer I/O error on dev md112, logical block 0, async page read
[  +0.001307]  md112: unable to read partition table


So the array assembles, and raid6check reports no error, but the data
is actually inaccessible .. am I missing other aspects of the metadata
that need to be restored?


-- 
Giuseppe "Oblomov" Bilotta
