From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: RAID5 grow interrupted.
Date: Thu, 22 Sep 2016 19:19:15 +0200
Message-ID: <20160922171915.GA5392@metamorpher.de>
References: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
Sender: linux-raid-owner@vger.kernel.org
To: Axel Spallek <axel@spallek.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 22, 2016 at 04:11:28PM +0200, Axel Spallek wrote:
> I tried to get a disk out of a RAID5 with 8 hdds (4TB) to get a Hotspare 
> to change to RAID6 afterwards.

I'm a bit confused here.

You started out with 8 disk RAID-5? And final result is to be what?
RAID-6 with 8 disks?

> Therefore I issued the following commands:
> 
> mdadm --grow -n7 /dev/md1  <-- just to get the size for the next command.
> 
> mdadm --grow /dev/md1 --array-size 23441292288
> 
> mdadm --grow -n7 /dev/md1 --backup-file /var/backups/mdadm.backup

I'm not sure, but you might not have needed any of these intermediate steps. 
But now you started it you might have to finish them.
That said there is a reshape revert (which is not yet in the manpage?) 
which might help if the regular reshape just won't resume.

> root@s10:~# mdadm -A --scan --verbose
> mdadm: looking for devices for further assembly
> mdadm: /dev/sdg1 is busy - skipping

It says busy because already assembled (or in use by something else).
So you have to stop first before assembeling again.

I didn't see anything out of place in your --examine.
It seems to be in sync, event count identical, ....

Good luck
Andreas Klauer
