From: Ole Tange <tange@binf.ku.dk>
Subject: Re: Help with recovering a RAID5 array
Date: Fri, 3 May 2013 10:38:52 +0200
Message-ID: <CANU9nTnwx_3m3Ggebxgfe1RqKU6OMk59qnhecSmYvmC2cUeRnw@mail.gmail.com>
References: <34199580.p6EyCyMeIZ@chablis>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34199580.p6EyCyMeIZ@chablis>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Borggraefe <stefan@spybot.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 2, 2013 at 2:24 PM, Stefan Borggraefe <stefan@spybot.info> wrote:

> I am using a RAID5 software RAID on Ubuntu 12.04
:
> It consits of 6 Hitachi drives with 4 TB and contains an ext 4 file system.
>
> When I returned to this server this morning, the array was in the following
> state:
>
> md126 : active raid5 sdc1[7](S) sdh1[4] sdd1[3](F) sde1[0] sdg1[6] sdf1[2]
>       19535086080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/4]
> [U_U_UU]
>
> sdc is the newly added hard disk, but now also sdd failed. :( It would be
> great if there was a way to have the this RAID5 working again. Perhaps sdc1
> can then be fully added to the array and after this drive sdd also exchanged.

I have had a few raid6 fail in a similar fashion: the 3rd drive
faliing during rebuild (Also 4 TB Hitachi by the way).

I tested if the drives were fine:

  parallel dd if={} of=/dev/null bs=1000k ::: /dev/sd?

And they were all fine. If the failing drive had actually failed (i.e.
bad sector), then I would use GNU ddrescue to copy the failing drive
to a new drive. ddrescue can read forwards on a drive, but can also
read backwards. Even though backwards reading is slower, you can use
that to approach the failing sector from "the other side". This way
you can often get down to very few actually failing sectors.

With only a few failing sectors (if any) I figured that very little
would be lost by forcing the failing drive online. Remove the spare
drive, and force the remaining online:

  mdadm -A --scan --force

This should not cause any rebuild to happen as you have removed the spare.

See: http://serverfault.com/questions/443763/linux-software-raid6-3-drives-offline-how-to-force-online

Next step is to do fsck. Since fsck will write to the disk (and thus
be impossible to revert from) I put an overlay on the md-device, so
that nothing was written to the disks - instead changes were simply
written to a file.

See: http://unix.stackexchange.com/questions/67678/gnu-linux-overlay-block-device-stackable-block-device

This overlayed device I then ran fsck on. Then I checked everything
was OK. When everything was OK, I removed the overlay and did the fsck
on the real drives.

Thinking back it might even have made sense to overlay every
underlying block device, thus ensuring that nothing (not even the
md-driver) wrote anything to the devices before I as ready to commit.


/Ole
