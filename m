From: Neil Brown <neilb@suse.de>
Subject: Re: reshape changing chunk size won't restart
Date: Wed, 22 Dec 2010 09:16:19 +1100
Message-ID: <20101222091619.36788b42@notabene.brown>
References: <1292961697.20216.0@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292961697.20216.0@athlon>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 21 Dec 2010 12:01:37 -0800 Andrew Burgess <aab@cichlid.com> wrote:

> mdadm 3.14
> kernel 2.6.35.8
> 
> I started a reshape changing chunk size and after it ran
> for a while i realized the disk i used for the
> backup file was slow so I killed the mdadm

That was a mistake.

> running in the background and tried to restart
> with the new location (i moved the file just in case)
> 
> mdadm /dev/md5 --grow --chunk=8 --backup-file=/my/raid/RAID_BACKUP_FILE

As you discovered, that doesn't work.  I'd like to make it possible to do
something like that, but time is not something I have a lot of.

> 
> it complains:
> 
> mdadm: /dev/md5 is performing resync/recovery and cannot be reshaped
> 
> /proc/mdstat for md5 shows partial progress but the numbers don't change
> (except finish grows):
> 
> md5 : active raid6 sdd1[2] sdf1[8] sdc1[1] sdb1[0] sdh1[4] sdl1[5]  
> sdj1[3] sdg1[7] sdk1[6]
>        13674583552 blocks super 0.91 level 6, 128k chunk, algorithm 2  
> [9/9] [UUUUUUUUU]
>        [>....................]  reshape =  0.1% (2715648/1953511936)  
> finish=850711.5min speed=38K/sec
> 
> The mdadm 3.14 is freshly compiled. I started the reshape
> with mdadm 3.13.
> 
> I didn't try rebooting as the filesystem is mounted and
> the data seems ok. Didn't want to make things worse...

It shouldn't make things worse.
Do don't need to reboot, unless md5 has your root filesystem.
Just unmount, 'mdadm -S /dev/md5', and assemble:
  mdadm -A /dev/md5 --backup-file=/whereever-you-copied-the-file-to \
      /dev/sd[dfcbhljgk]1

should do it.

NeilBrown


> 
> Thank you for any help
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

