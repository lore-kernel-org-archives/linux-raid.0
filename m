From: linux-raid-kernel-org@moniker.net
Subject: array sync looping
Date: Fri, 08 Dec 2006 16:19:16 +1100
Message-ID: <4578F5D4.8080205@moniker.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi -

I recently upgraded to the 2.6.17-2-686 SMP kernel image (debian).

Now, when I hot-add a disk (mdadm /dev/md1 --add /dev/hdc3) the array 
resyncs to 100%, a bunch of errors appear and then the array resync 
starts from 0% again.

mdadm --zero-superblock on the "new" disk doesn't help.

Any suggestions on what might be happening or how to debug/fix would 
be welcome.

Thanks -

Leni

$ dmesg  # output truncated
...
md: md1: sync done.
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=390716106, 
high=23, low=4840138, sector=390716042
ide: failed opcode was: unknown
end_request: I/O error, dev hda, sector 390716042
...
raid1: hda: unrecoverable I/O read error for block 388499072
RAID1 conf printout:
  --- wd:1 rd:3
  disk 0, wo:1, o:1, dev:hdc3
  disk 2, wo:0, o:1, dev:hda3
RAID1 conf printout:
  --- wd:1 rd:3
  disk 2, wo:0, o:1, dev:hda3
RAID1 conf printout:
  --- wd:1 rd:3
  disk 0, wo:1, o:1, dev:hdc3
  disk 2, wo:0, o:1, dev:hda3
md: syncing RAID array md
...
