From: Andrew Burgess <aab@cichlid.com>
Subject: Re: reshape changing chunk size won't restart
Date: Tue, 21 Dec 2010 16:09:59 -0800
Message-ID: <1292976599.598.0@athlon>
References: <20101222091619.36788b42@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101222091619.36788b42@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/21/2010 02:16:19 PM, Neil Brown wrote:

> > I started a reshape changing chunk size and after it ran
> > for a while i realized the disk i used for the
> > backup file was slow so I killed the mdadm
> 
> That was a mistake.

Its looking to be a bad one

> > running in the background and tried to restart
> > with the new location (i moved the file just in case)
> >
> > mdadm /dev/md5 --grow --chunk=8  
> --backup-file=/my/raid/RAID_BACKUP_FILE
> 
> As you discovered, that doesn't work.  I'd like to make it possible  
> to do
> something like that, but time is not something I have a lot of.

Understand 100%

> > I didn't try rebooting as the filesystem is mounted and
> > the data seems ok. Didn't want to make things worse...
> 
> It shouldn't make things worse.

I had too because umount wouldn't and neither fuser nor lsof
could find the guilty party

> Do don't need to reboot, unless md5 has your root filesystem.
> Just unmount, 'mdadm -S /dev/md5', and assemble:
>   mdadm -A /dev/md5 --backup-file=/whereever-you-copied-the-file-to \
>       /dev/sd[dfcbhljgk]1
> 
> should do it.

After rebooting something happened to sdg1:

mdadm -A /dev/md5 --backup-file=/my/raid/RAID_BACKUP_FILE  
/dev/sd[dfcbhljgk]1
mdadm: cannot open device /dev/sdg1: No such device or address
mdadm: /dev/sdg1 has no superblock - assembly aborted

so i tried it with sdg1 missing

mdadm -A /dev/md5 --backup-file=/my/raid/RAID_BACKUP_FILE  
/dev/sd[dfcbhljk]1
mdadm: Failed to restore critical section for reshape, sorry.

so i rebooted and power cycled hoping to get sdg1 back but it was
still unhappy with the superblock

I even tried it letting it scan for devices:

mdadm -A /dev/md5 --backup-file=/my/raid/RAID_BACKUP_FILE
mdadm: WARNING /dev/sdg1 and /dev/sdg appear to have very similar  
superblocks.
       If they are really different, please --zero the superblock on one
       If they are the same or overlap, please remove one from the
       DEVICE list in mdadm.conf.

so repeating with all but sdg1 specified it results in:

mdadm: Failed to restore critical section for reshape, sorry.

Anything else I can try? We do have the sector it was on in the original
email when it stopped: (2715648/1953511936)
