From: Phil Turmel <philip@turmel.org>
Subject: Re: Reshape 3-drive RAID1 into 3-drive RAID-5
Date: Tue, 15 Nov 2011 16:11:43 -0500
Message-ID: <4EC2D58F.3070508@turmel.org>
References: <CAK2H+ed1M=_N5rW5Y72Cm0_74ii=-9dCMsB7xJR4FGMST4rCjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ed1M=_N5rW5Y72Cm0_74ii=-9dCMsB7xJR4FGMST4rCjA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

On 11/15/2011 10:13 AM, Mark Knecht wrote:
> Hi all,
>    I have an existing 3-drive RAID-1 (md6) that I use as a short term
> backup device for a 5-drive RAID-6 (md7) on this machine. The _only_
> purpose of this internal backup RAID-1 is to protect against a
> fat-finger 'oops' event when using VMWare or Virtualbox VMs on md7.
> Real data backups happen over the network to other machines but that's
> slow and only gets done about once a week. With this local storage I
> can do it in just a few minutes every day.
> 
>    I recently reshaped the RAID-6 from a 5-drive RAID-1and now it's
> larger than this local backup so I can't get everything backed up any
> more. I.e. - I need /dev/md6 large enough to back up /dev/md7. With 3
> existing 235GB partitions I believe the RAID-5 will be about 470GB
> when complete and therefore large enough to hold my 400GB RAID-6 data.
> 
>    I would like to verify that the right commands to do this would be:
> 
> umount /dev/md6
> mdadm --stop /dev/md6
> mdadm --create /dev/md6 --level=5 --raid-devices=3 /dev/sda6 /dev/sdb6 /dev/sdc6

This will blow away the contents, but will otherwise work.  After the
--create, MD will spend time generating parity for the third disk from
the other two.

>    If these commands are wrong or anyone thinks there are other things
> I should be doing at this time please speak up as I'm interested.
> 
>    The data that's currently on the backup is not terribly important
> but if possible I'd like to keep it through this process unless doing
> so makes things more difficult. The time it takes to do this reshape
> is not terribly important to me.

In your case, the data can be retained, and even remain in use, as follows:

1) Drop the third device and wipe its superblock.

mdadm /dev/md6 --fail /dev/sdc6 --remove /dev/sdc6
mdadm --zero-superblock /dev/sdc6

2) Convert 2-drive raid1 to 2-drive raid5.  Due to a quirk of the parity math, the second drive contains the same data as the first, and Neil has optimized this conversion to be instant.  (I don't know what version that became true, but I believe it has been a while.)

mdadm /dev/md6 --grow --level=5

3) Add third drive as a spare:

mdadm /dev/md6 --add /dev/sdc6

4) Reshape/grow to use the new space.  MD will re-arrange the blocks and compute parity as it goes, without disturbing the running filesystem.  You probably need a backup-file option as well...  mdadm will tell you if it needs it.

mdadm /dev/md6 --grow --raid-devices=3

5) Resize your filesystem to use the additional space.

.... (varies, some FS can do it on the run.)

> 
> Thanks,
> Mark

HTH,

Phil
