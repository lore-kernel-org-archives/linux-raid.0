From: Eurijk <eurijk@zefga.net>
Subject: Raid 5 on 2.5.50/2.5.51, dirty array, kernel panic
Date: Tue, 10 Dec 2002 23:34:43 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021210233443.48053fe3.eurijk@zefga.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I set up an IDE raid array as such:
  /dev/md1 hda1 hdc1 hde1 hdg1 RAID 1
  /dev/md0 hda2 hdc2 hde2 hdg2 RAID 5

Installed slack, set up lilo, and waited for rebuilding to finish.
Now to simulate a failure I shut it down and physically unhooked
(**boom hellfire fury**! :D) /dev/hda. From everything I understand,
the system should work just fine still.

Bios detects hdc is still there, and auto boots off that. Kernel loads,
good lilo did it's job :D, but...:

...
md: created md0
...
md: running: <hdg2><hde2><hdc2>
md: md0: raid array is not clean -- starting background reconstuction
...
raid5: device hdg2 operational as raid disk 3
raid5: device hde2 operational as raid disk 2
raid5: device hdc2 operational as raid disk 1
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 1, o:1, dev:hdc2
 disk 2, o:1, dev:hde2
 disk 3, o:1, dev:hdg2
raid5: failed to run raid set md0
md: pers->run() failed ...
md :do_md_run() returned -22
md: md0 still in use.
...
raid1: raid set md1 active with 3 out of 4 mirrors
...
md: ... autorun DONE.
Unable to handle kernel NULL pointer dereference at virtual address 00000088
 printing eip:
c0289977
(stack/register dump is here :D)
...
 <0>Kernel panic: Attempted to kill init!

The "cannot start dirty degraded array" was added in 2.5.34 I believe. I can't
test a pre 2.5.34 since my 20271 was added in 2.5.37. >;-) I can test it using
good ol' hda/hdb/hdc/hdd if it would be of some help.

Let me know if I'm off my rocker!

Thanks

-eurijk!
