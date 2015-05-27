From: Xiao Ni <xni@redhat.com>
Subject: Re: raid5 reshape is stuck
Date: Wed, 27 May 2015 07:28:04 -0400 (EDT)
Message-ID: <2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com> <20150521094837.6a2d29c4@notabene.brown> <1552584910.2141570.1432179477679.JavaMail.zimbra@redhat.com> <1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com> <20150525135001.43d1083a@notabene.brown> <427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com> <20150527100253.221ab553@notabene.brown> <20150527111004.5f136f23@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150527111004.5f136f23@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Wednesday, May 27, 2015 9:10:04 AM
> Subject: Re: raid5 reshape is stuck
> 
> On Wed, 27 May 2015 10:02:53 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > On Tue, 26 May 2015 06:48:23 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> > 
> > 
> > > > >    
> > > > >    In the function continue_via_systemd the parent find pid is bigger
> > > > >    than
> > > > >    0 and
> > > > > status is 0. So it return 1. So it have no opportunity to call
> > > > > child_monitor.
> > > >
> > > > If continue_via_systemd succeeded, that implies that
> > > >   systemctl start mdadm-grow-continue@mdXXX.service
> > > >
> > > > succeeded.  So
> > > >    mdadm --grow --continue /dev/mdXXX
> > > >
> > > > was run, so that mdadm should call 'child_monitor' and update sync_max
> > > > when
> > > > appropriate.  Can you check if it does?
> > > 
> > > The service is not running.
> > > 
> > > [root@intel-waimeabay-hedt-01 create_assemble]# systemctl start
> > > mdadm-grow-continue@md0.service
> > > [root@intel-waimeabay-hedt-01 create_assemble]# echo $?
> > > 0
> > > [root@intel-waimeabay-hedt-01 create_assemble]# systemctl status
> > > mdadm-grow-continue@md0.service
> > > mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
> > >    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service;
> > >    static)
> > >    Active: failed (Result: exit-code) since Tue 2015-05-26 05:33:59 EDT;
> > >    21s ago
> > >   Process: 5374 ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I
> > >   (code=exited, status=1/FAILURE)
> > >  Main PID: 5374 (code=exited, status=1/FAILURE)
> > > 
> > > May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com
> > > systemd[1]: Started Manage MD Reshape on /dev/md0.
> > > May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com
> > > systemd[1]: mdadm-grow-continue@md0.service: main process exited, ...URE
> > > May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com
> > > systemd[1]: Unit mdadm-grow-continue@md0.service entered failed state.
> > > Hint: Some lines were ellipsized, use -l to show in full.
> > 
> > Hmm.. I wonder why systemctl isn't reporting the error message from mdadm.

I don't know the reason too. The return value $? is 0 after run systemctl start.
But the status is failed.
 
> > 
> > 
> > > 
> > > [root@intel-waimeabay-hedt-01 create_assemble]# mdadm --grow --continue
> > > /dev/md0 --backup-file=tmp0
> > > mdadm: Need to backup 6144K of critical section..
> > > 
> > > Now the reshape start.
> > > 
> > > Try modify the service file :
> > > ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I
> > > --backup-file=/root/tmp0
> > > 
> > > It doesn't work too.
> > 
> > I tried that change and it make it work.

[root@intel-waimeabay-hedt-01 mdadm]# cat /usr/lib/systemd/system/mdadm-grow-continue\@.service 
#  This file is part of mdadm.
#
#  mdadm is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.

[Unit]
Description=Manage MD Reshape on /dev/%I
DefaultDependencies=no

[Service]
ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I --backup-file=/root/tmp0
StandardInput=null
StandardOutput=null
StandardError=null
KillMode=none
[root@intel-waimeabay-hedt-01 mdadm]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      1532928 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [>....................]  reshape =  0.0% (0/510976) finish=532.2min speed=0K/sec
      
unused devices: <none>
[root@intel-waimeabay-hedt-01 mdadm]# systemctl start mdadm-grow-continue@md0.service
[root@intel-waimeabay-hedt-01 mdadm]# systemctl status mdadm-grow-continue@md0.service
mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
   Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; static)
   Active: failed (Result: exit-code) since Wed 2015-05-27 02:45:40 EDT; 12s ago
  Process: 24596 ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I --backup-file=/root/tmp0 (code=exited, status=1/FAILURE)
 Main PID: 24596 (code=exited, status=1/FAILURE)

May 27 02:45:40 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: Started Manage MD Reshape on /dev/md0.
May 27 02:45:40 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: mdadm-grow-continue@md0.service: main process exited, ...URE
May 27 02:45:40 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: Unit mdadm-grow-continue@md0.service entered failed state.
Hint: Some lines were ellipsized, use -l to show in full.

It's still failed after changing the file. 


> > 
> > > 
> > > [root@intel-waimeabay-hedt-01 ~]# systemctl daemon-reload
> > > [root@intel-waimeabay-hedt-01 ~]# systemctl start
> > > mdadm-grow-continue@md0.service
> > > [root@intel-waimeabay-hedt-01 ~]# systemctl status
> > > mdadm-grow-continue@md0.service
> > > mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
> > >    Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service;
> > >    static)
> > >    Active: failed (Result: exit-code) since Tue 2015-05-26 05:50:22 EDT;
> > >    10s ago
> > >   Process: 6475 ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I
> > >   --backup-file=/root/tmp0 (code=exited, status=1/FAILURE)
> > >  Main PID: 6475 (code=exited, status=1/FAILURE)
> > > 
> > > May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com
> > > systemd[1]: Started Manage MD Reshape on /dev/md0.
> > > May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com
> > > systemd[1]: mdadm-grow-continue@md0.service: main process exited, ...URE
> > > May 26 05:50:22 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com
> > > systemd[1]: Unit mdadm-grow-continue@md0.service entered failed state.
> > > Hint: Some lines were ellipsized, use -l to show in full.
> > > 
> > > 
> > >   
> > > >
> > > >
> > > > >
> > > > >
> > > > >    And if it want to set sync_max to 0 until the backup has been
> > > > >    taken. Why
> > > > >    does not
> > > > > set sync_max to 0 directly, but use the value reshape_progress? There
> > > > > is a
> > > > > little confused.
> > > >
> > > > When reshaping an array to a different array of the same size, such as
> > > > a
> > > > 4-driver RAID5 to a 5-driver RAID6, then mdadm needs to backup, one
> > > > piece at
> > > > a time, the entire array (unless it can change data_offset, which is a
> > > > relatively new ability).
> > > >
> > > > If you stop an array when it is in the middle of such a reshape, and
> > > > then
> > > > reassemble the array, the backup process need to recommence where it
> > > > left
> > > > off.
> > > > So it tells the kernel that the reshape can progress as far as where it
> > > > was
> > > > up to before.  So 'sync_max' is set based on the value of
> > > > 'reshape_progress'.
> > > > (This will happen almost instantly).
> > > >
> > > > Then the background mdadm (or the mdadm started by systemd) will backup
> > > > the
> > > > next few stripes, update sync_max, wait for those stripes to be
> > > > reshaped,
> > > > then
> > > > discard the old backup, create a new one of the few stripes after that,
> > > > and
> > > > continue.
> > > >
> > > > Does that make it a little clearer?
> > > 
> > > This is a big dinner for me. I need digest this for a while. Thanks very
> > > much
> > > for this. What's the "backup process"?
> > > 
> > > Could you explain backup in detail. I read the man about backup file.
> > > 
> > > When  relocating the first few stripes on a RAID5 or RAID6, it is not
> > > possible to keep the data on disk completely
> > > consistent and crash-proof.  To provide the required safety, mdadm
> > > disables writes to the array while this "critical
> > > section"  is reshaped, and takes a backup of the data that is in that
> > > section.
> > > 
> > > What's the reason about data consistent when relocate data?
> > 
> > If you are reshaping a RAID5 from 3 drives to 4 drives, then the first
> > stripe
> > will start out as:
> > 
> >    D0  D1   P   -
> > 
> > and you want to change it to
> > 
> >    D0  D1   D2  P
> > 
> > If the system crashes while that is happening, you won't know if either or
> > both of D2 and P were written, but it is fairly safe just to assume they
> > weren't and recalculate the parity.
> > However the second stripe will initially be:
> > 
> >    P  D2  D3
> > 
> > and you want to change it to
> > 
> >    P  D3  D4  D5
> > 
> > If you crash in the middle of doing that you cannot know which block is D3
> > - if either.  D4 might have been written, and D3 not yet written.  So D3 is
> > lost.
> > 
> > So mdadm takes a copy of a whole stripe, allows the kernel to reshape that
> > one stripe, updates the metadata to record that the stripe has been fully
> > reshaped, and then discards the backup.
> > So if you crash in the middle of reshaping the second stripe above, mdadm
> > will restore it from the backup.
> > 
> > The backup can be stored in a separate file, or in a device which is being
> > added to the array.
> > 
> > 
> > The reason why "mdadm --grow --continue" doesn't work unless you add the
> > "--backup=...." is because it doesn't find the "device  being added" - it
> > looks for a spare, but there aren't any spares any more.   That should be
> > easy enough to fix.


   :) I got this. Thanks for the details 
> 
> That wasn't too painful - I think this fixes the problem.
> Could you confirm?
> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/Grow.c b/Grow.c
> index a20ff3e70142..85de1d27f03a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -850,7 +850,8 @@ int reshape_prepare_fdlist(char *devname,
>  	for (sd = sra->devs; sd; sd = sd->next) {
>  		if (sd->disk.state & (1<<MD_DISK_FAULTY))
>  			continue;
> -		if (sd->disk.state & (1<<MD_DISK_SYNC)) {
> +		if (sd->disk.state & (1<<MD_DISK_SYNC) &&
> +		    sd->disk.raid_disk < raid_disks) {
>  			char *dn = map_dev(sd->disk.major,
>  					   sd->disk.minor, 1);
>  			fdlist[sd->disk.raid_disk]
> @@ -3184,7 +3185,7 @@ started:
>  	d = reshape_prepare_fdlist(devname, sra, odisks,
>  				   nrdisks, blocks, backup_file,
>  				   fdlist, offsets);
> -	if (d < 0) {
> +	if (d < odisks) {
>  		goto release;
>  	}
>  	if ((st->ss->manage_reshape == NULL) ||
> @@ -3196,7 +3197,7 @@ started:
>  				       devname);
>  				pr_err(" Please provide one with \"--backup=...\"\n");
>  				goto release;
> -			} else if (sra->array.spare_disks == 0) {
> +			} else if (d == odisks) {
>  				pr_err("%s: Cannot grow - need a spare or backup-file to backup critical
>  				section\n", devname);
>  				goto release;
>  			}
> 
> 

  I tried this, it doesn't work. 
