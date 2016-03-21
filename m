From: "Patrick Tschackert" <Killing-Time@gmx.de>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 23:19:03 +0100
Message-ID: <trinity-d8aad971-9614-4e9c-97ec-f96c279f2157-1458598743708@3capp-gmx-bs35>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Philip, thanks for answering!

> Your smartctl output shows pending sector problems with sdf, sdh, and
> sdj.  The latter are WD Reds that won't keep those problems through a
> scrub, so I guess the smartctl report was from before that?

The smartctl results are "fresh", i ran the commands just before sending my last eMail.

>> mdadm --examine output for your disks?
>Yes, we want these.

Here: http://pastebin.com/JW8rbJYY

> Your mdadm -D output clearly shows a 2014 creation date,
> so you definitely hadn't done --create --assume-clean at that point.
> (Don't.)

I didn't do that, I used mdadm --run /dev/md0 to start the rebuild/restore

> Something else is wrong, quite possibly hardware.  You don't get a
> mismatch count like that without it showing up in smartctl too, unless
> corrupt data was being written to one or more disks for a long time.

As I said in my initial eMail, I got

$ cat /sys/block/md0/md/mismatch_cnt
0

directly after the rebuild/restore. I then ran

$ for i in /sys/class/scsi_generic/*/device/timeout; do echo 120 > "$i"; done

to correct disk timeouts (got that advice from irc) and

$ echo check > /sys/block/md0/md/sync_action

to start a check on the raid. After the check was completed i got

$ cat /sys/block/md0/md/mismatch_cnt
311936608

> If you used ddrescue to replace sdf instead of letting mdadm reconstruct
> it, that would have introduced zero sectors that would scramble your
> encrypted filesystem.  Please let us know that you didn't use ddrescue.

I didn't do that, I just ran mdadm --run /dev/md0, which started the rebuild, nothing else.


> The encryption inside your array will frustrate any attempt to do
> per-member analysis.  I don't think there's anything still wrong with
> the array (anything fixable, that is).
> If an array error stomped on the key area of your dm-crypt layer, you
> are totally destroyed, unless you happen to have a key backup you can
> restore.
> Otherwise you are at the mercy of fsck to try to fix your volume.  I
> would use an overlay for that.

Well, the key area seems alright, i can open the volume using "cryptsetup luksOpen /dev/md0 storage", it asks for my passphrase and then opens the volume.
I can even read the BTRFS superblock (of the filesys on my luks volume), so the whole thing doesn't seem to be completely borked.
I'll read up on overlays and try them maybe.

Kind regards
