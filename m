From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: recovery from selinux blocking --backup-file during RAID5->6
Date: Tue, 5 Apr 2016 12:14:39 +0100
Message-ID: <57039E1F.3060307@youngman.org.uk>
References: <CAFAW0zxisX2Db_YdJxtNpF4YKayy=AnKnWcGdAgw6piy1Jjyng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFAW0zxisX2Db_YdJxtNpF4YKayy=AnKnWcGdAgw6piy1Jjyng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Noah Beck <noah.b.beck@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

DO YOU HAVE A BACKUP :-)

Actually, I think this doesn't sound too serious, if it's just the spare
that's failed, you've still got redundancy. If you'd lost an active
drive I'd be screaming "backups!!! backups!!! backups!!!".

My reaction is simply to replace the failed drive and then carry on the
conversion, but I'm not an expert.

Thing is, when one drive fails, it should be ringing alarm bells that
another one is on its last legs - these things have an annoying habit of
failing in bunches. Which says that you really need a *second* spare
drive handy - is the rebuild going to tip one of your live drives over
the edge? I'd say the chances of you ending up with a 5-device raid-6
with one device failed is a lot higher than you'd like :-(

Cheers,
Wol

On 05/04/16 04:16, Noah Beck wrote:
> I see a similar problem has been discussed at least once before at
> https://marc.info/?t=144970286700004&r=1&w=2
> 
> In my case, this was a RAID5 array with 4 active devices and one
> spare.  I wanted to switch this to a 5-device RAID6 instead.  Ran the
> following:
> 
>   mdadm --grow /dev/md127 --raid-devices 5 --level 6 --backup-file
> /root/raid_migration_file
> 
> Two things went wrong:
> 
> 1) selinux jumped in and blocked access to the --backup-file.  From journalctl:
> 
>   SELinux is preventing mdadm from getattr access on the file
> /root/raid_migration_file
> 
> This can be fixed with a "setenforce 0" in the future.  The
> /root/raid_migration_file did get created (25MB) but hexdump says it
> is all zeros so I believe no useful data was placed in this file.
> 
> 2) Turns out my spare device in the old RAID5 was actually ready to
> die.  This corresponds to what was previously the spare in my RAID5:
> 
>   ata4.00: revalidation failed (errno=-2)
>   ata4.00: disabled
>   ata4: EH complete
>   blk_update_request: I/O error, dev sdb, sector 0
>   blk_update_request: I/O error, dev sdb, sector 3907023935
>   md: super_written gets error=-5
>   md/raid:md127: Disk failure on sdb1, disabling device.
>   md/raid:md127: Operation continuing on 4 devices.
> 
> Since /dev/sdb1 was marked as failed in the array I removed it.  I
> tried zeroing it out with dd if=/dev/zero of=/dev/sdb1 to see what it
> would do and then that disk completely died.  So I'll get a new disk
> tomorrow.  In the meantime the system still seems to be running fine.
> /proc/mdstat shows this now:
> 
>   md127 : active raid6 sde1[3] sda1[2] sdd1[0] sdf1[1]
>       5860535808 blocks super 0.91 level 6, 64k chunk, algorithm 18
> [5/4] [UUUU_]
>       [>....................]  reshape =  0.0% (1/1953511936)
> finish=722.0min speed=43680K/sec
> 
> The previous thread resulted in a patch (in
> https://marc.info/?l=linux-raid&m=145187378405337&w=2 ).  If I want to
> go back to having a 4-device RAID5 array before I shut this system
> down to replace the bad disk, is the right thing to do still to apply
> that patch to mdadm, stop /dev/md127, and assemble again with
> --update=revert-reshape?  Or does the info above indicate I should use
> any different solution?
> 
> Thanks,
> Noah
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

