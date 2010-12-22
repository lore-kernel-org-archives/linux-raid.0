From: Neil Brown <neilb@suse.de>
Subject: Re: reshape changing chunk size won't restart
Date: Wed, 22 Dec 2010 13:29:35 +1100
Message-ID: <20101222132935.01d140c1@notabene.brown>
References: <20101222120810.5bba5304@notabene.brown>
	<1292983786.5543.1@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292983786.5543.1@athlon>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 21 Dec 2010 18:09:46 -0800 Andrew Burgess <aab@cichlid.com> wrote:

> On 12/21/2010 05:08:10 PM, Neil Brown wrote:
> > On Tue, 21 Dec 2010 16:09:59 -0800 Andrew Burgess <aab@cichlid.com>  
> > wrote:
> > 
> > > On 12/21/2010 02:16:19 PM, Neil Brown wrote:
> > >
> > > > > I started a reshape changing chunk size and after it ran
> > > > > for a while i realized the disk i used for the
> > > > > backup file was slow so I killed the mdadm
> > > >
> > > > That was a mistake.
> > >
> > > Its looking to be a bad one
> > >
> > > > > running in the background and tried to restart
> > > > > with the new location (i moved the file just in case)
> > > > >
> > > > > mdadm /dev/md5 --grow --chunk=8
> > > > --backup-file=/my/raid/RAID_BACKUP_FILE
> > > >
> > > > As you discovered, that doesn't work.  I'd like to make it  
> > possible
> > > > to do
> > > > something like that, but time is not something I have a lot of.
> > >
> > > Understand 100%
> > >
> > > > > I didn't try rebooting as the filesystem is mounted and
> > > > > the data seems ok. Didn't want to make things worse...
> > > >
> > > > It shouldn't make things worse.
> > >
> > > I had too because umount wouldn't and neither fuser nor lsof
> > > could find the guilty party
> > >
> > > > Do don't need to reboot, unless md5 has your root filesystem.
> > > > Just unmount, 'mdadm -S /dev/md5', and assemble:
> > > >   mdadm -A /dev/md5  
> > --backup-file=/whereever-you-copied-the-file-to \
> > > >       /dev/sd[dfcbhljgk]1
> > > >
> > > > should do it.
> > >
> > > After rebooting something happened to sdg1:
> > >
> > > mdadm -A /dev/md5 --backup-file=/my/raid/RAID_BACKUP_FILE
> > > /dev/sd[dfcbhljgk]1
> > > mdadm: cannot open device /dev/sdg1: No such device or address
> > > mdadm: /dev/sdg1 has no superblock - assembly aborted
> > >
> > > so i tried it with sdg1 missing
> > >
> > > mdadm -A /dev/md5 --backup-file=/my/raid/RAID_BACKUP_FILE
> > > /dev/sd[dfcbhljk]1
> > > mdadm: Failed to restore critical section for reshape, sorry.
> > >
> > > so i rebooted and power cycled hoping to get sdg1 back but it was
> > > still unhappy with the superblock
> > >
> > > I even tried it letting it scan for devices:
> > >
> > > mdadm -A /dev/md5 --backup-file=/my/raid/RAID_BACKUP_FILE
> > > mdadm: WARNING /dev/sdg1 and /dev/sdg appear to have very similar
> > > superblocks.
> > >        If they are really different, please --zero the superblock  
> > on one
> > >        If they are the same or overlap, please remove one from the
> > >        DEVICE list in mdadm.conf.
> > >
> > > so repeating with all but sdg1 specified it results in:
> > >
> > > mdadm: Failed to restore critical section for reshape, sorry.
> > >
> > > Anything else I can try? We do have the sector it was on in the  
> > original
> > > email when it stopped: (2715648/1953511936)
> > 
> > 
> > The business with sdg1 is a bit odd... I would use "--examine" to  
> > check each
> > device and make sure they have good matching superblocks.  It would  
> > be a lot
> > better if you can make sure all devices get included when you start  
> > the array.
> 
> all the working devices have the same Reshape pos'n value in the  
> superblock.
> sdg1 though:
> 
> mdadm -E /dev/sdg1
> mdadm: cannot open /dev/sdg1: No such device or address

Maybe it has forgotten it's partition table... try

  blockdev --rereadpt /dev/sdg

(check man page to make sure I have the right spell.  Definitely sdg, not
sdg1).

> 
> even though:
> 
> ls -l /dev/sdg*
> brw-rw---- 1 root disk 8, 96 Dec 21 15:53 /dev/sdg
> brw-rw---- 1 root disk 8, 97 Dec 21 15:55 /dev/sdg1
> 
> and the partition table looks ok.
> sdg is brand new but there are no i/o errors in the log
> 
> > Also, try starting with '--verbose', it might give some useful  
> > information,
> > but I don't hold out a lot of hope.
> 
> unless old timestamp is helpful:

Yes, it is.  Makes sense too.
I never really didn't get the timestamp logic straight in my mind.

Try

  MDADM_GROW_ALLOW_OLD=1  mdadm --verbose -A ....

and see how that goes.  Requires mdadm-3.1.2 or later which I think you have.


NeilBrown

> 
> mdadm --verbose -A /dev/md5 --backup-file=/my/raid/RAID_BACKUP_FILE   
> /dev/sd[dfcbhljk]1
> mdadm: looking for devices for /dev/md5
> mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 0.
> mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 2.
> mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 8.
> mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 4.
> mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 3.
> mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 6.
> mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 5.
> mdadm:/dev/md5 has an active reshape - checking if critical section  
> needs to be restored
> mdadm: too-old timestamp on backup-metadata on /my/raid/RAID_BACKUP_FILE
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
> 
> > Finally, you will probably end up having to modify mdadm so that it  
> > ignores a
> > failure from Grow_restart.  AS you had a reasonably clean shutdown  
> > rather
> > than a crash, there is a good chance that the backup file isn't  
> > actually
> > needed.
> 
> If the timestamp info above doesn't change your mind then I'll
> try that.
> 
> > The next release of mdadm will have a --invalid-backup option to  
> > --assemble
> > to tell it to just continue even though the backup file looks wrong.
> 
> Hope to send you a patch for that.
> 
> Thanks for your time!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

