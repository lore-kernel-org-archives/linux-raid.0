From: Xiao Ni <xni@redhat.com>
Subject: Re: raid5 reshape is stuck
Date: Tue, 26 May 2015 06:00:58 -0400 (EDT)
Message-ID: <1096866726.4083962.1432634458863.JavaMail.zimbra@redhat.com>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com> <2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com> <20150521094837.6a2d29c4@notabene.brown> <1552584910.2141570.1432179477679.JavaMail.zimbra@redhat.com> <1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com> <20150525135001.43d1083a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150525135001.43d1083a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Monday, May 25, 2015 11:50:01 AM
> Subject: Re: raid5 reshape is stuck
> 
> On Thu, 21 May 2015 08:31:58 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> > 
> > 
> > ----- Original Message -----
> > > From: "Xiao Ni" <xni@redhat.com>
> > > To: "NeilBrown" <neilb@suse.de>
> > > Cc: linux-raid@vger.kernel.org
> > > Sent: Thursday, May 21, 2015 11:37:57 AM
> > > Subject: Re: raid5 reshape is stuck
> > > 
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "NeilBrown" <neilb@suse.de>
> > > > To: "Xiao Ni" <xni@redhat.com>
> > > > Cc: linux-raid@vger.kernel.org
> > > > Sent: Thursday, May 21, 2015 7:48:37 AM
> > > > Subject: Re: raid5 reshape is stuck
> > > > 
> > > > On Fri, 15 May 2015 03:00:24 -0400 (EDT) Xiao Ni <xni@redhat.com>
> > > > wrote:
> > > > 
> > > > > Hi Neil
> > > > > 
> > > > >    I encounter the problem when I reshape a 4-disks raid5 to raid5.
> > > > >    It
> > > > >    just
> > > > >    can
> > > > > appear with loop devices.
> > > > > 
> > > > >    The steps are:
> > > > > 
> > > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm -CR /dev/md0 -l5 -n5
> > > > > /dev/loop[0-4]
> > > > > --assume-clean
> > > > > mdadm: /dev/loop0 appears to be part of a raid array:
> > > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > > mdadm: /dev/loop1 appears to be part of a raid array:
> > > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > > mdadm: /dev/loop2 appears to be part of a raid array:
> > > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > > mdadm: /dev/loop3 appears to be part of a raid array:
> > > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > > mdadm: /dev/loop4 appears to be part of a raid array:
> > > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > > mdadm: Defaulting to version 1.2 metadata
> > > > > mdadm: array /dev/md0 started.
> > > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm /dev/md0 -a /dev/loop5
> > > > > mdadm: added /dev/loop5
> > > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm --grow /dev/md0 --raid-devices
> > > > > 6
> > > > > mdadm: Need to backup 10240K of critical section..
> > > > > [root@dhcp-12-158 mdadm-3.3.2]# cat /proc/mdstat
> > > > > Personalities : [raid6] [raid5] [raid4]
> > > > > md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1]
> > > > > loop0[0]
> > > > >       8187904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]
> > > > >       [UUUUUU]
> > > > >       [>....................]  reshape =  0.0% (0/2046976)
> > > > >       finish=6396.8min
> > > > >       speed=0K/sec
> > > > >       
> > > > > unused devices: <none>
> > > > > 
> > > > >    It because the sync_max is set to 0 when run the command --grow
> > > > > 
> > > > > [root@dhcp-12-158 mdadm-3.3.2]# cd /sys/block/md0/md/
> > > > > [root@dhcp-12-158 md]# cat sync_max
> > > > > 0
> > > > > 
> > > > >    I tried reproduce with normal sata devices. The progress of
> > > > >    reshape is
> > > > >    no problem. Then
> > > > > I checked the Grow.c. If I use sata devices, in function
> > > > > reshape_array,
> > > > > the
> > > > > return value
> > > > > of set_new_data_offset is 0. But if I used loop devices, it return 1.
> > > > > Then
> > > > > it call the function
> > > > > start_reshape.
> > > > 
> > > > set_new_data_offset returns '0' if there is room on the devices to
> > > > reduce
> > > > the
> > > > data offset so that the reshape starts writing to unused space on the
> > > > array.
> > > > This removes the need for a backup file, or the use of a spare device
> > > > to
> > > > store a temporary backup.
> > > > It returns '1' if there was no room for relocating the data_offset.
> > > > 
> > > > So on your sata devices (which are presumably larger than your loop
> > > > devices)
> > > > there was room.  On your loop devices there was not.
> > > > 
> > > > 
> > > > > 
> > > > >    In the function start_reshape it set the sync_max to
> > > > >    reshape_progress.
> > > > >    But in sysfs_read it
> > > > > doesn't read reshape_progress. So it's 0 and the sync_max is set to
> > > > > 0.
> > > > > Why
> > > > > it need to set the
> > > > > sync_max at this? I'm not sure about this.
> > > > 
> > > > sync_max is set to 0 so that the reshape does not start until the
> > > > backup
> > > > has
> > > > been taken.
> > > > Once the backup is taken, child_monitor() should set sync_max to "max".
> > > > 
> > > > Can you  check if that is happening?
> > > > 
> > > > Thanks,
> > > > NeilBrown
> > > > 
> > > > 
> > > 
> > >   Thanks very much for the explaining. The problem maybe is fixed. I
> > >   tried
> > >   reproduce this with newest
> > > kernel and newest mdadm. Now the problem don't exist. I'll do more tests
> > > and
> > > give the answer above later.
> > > 
> > 
> > Hi Neil
> > 
> >    As you said, it doesn't enter child monitor. The problem still exist.
> > 
> > The kernel version :
> > [root@intel-canoepass-02 tmp]# uname -r
> > 4.0.4
> > 
> > mdadm I used is the newest git code from
> > git://git.neil.brown.name/mdadm.git
> > 
> >    
> >    In the function continue_via_systemd the parent find pid is bigger than
> >    0 and
> > status is 0. So it return 1. So it have no opportunity to call
> > child_monitor.
> 
> If continue_via_systemd succeeded, that implies that
>   systemctl start mdadm-grow-continue@mdXXX.service
> 
> succeeded.  So
>    mdadm --grow --continue /dev/mdXXX
> 
> was run, so that mdadm should call 'child_monitor' and update sync_max when
> appropriate.  Can you check if it does?


[root@intel-waimeabay-hedt-01 create_assemble]# systemctl start mdadm-grow-continue@md0.service
[root@intel-waimeabay-hedt-01 create_assemble]# echo $?
0
[root@intel-waimeabay-hedt-01 create_assemble]# systemctl status mdadm-grow-continue@md0.service
mdadm-grow-continue@md0.service - Manage MD Reshape on /dev/md0
   Loaded: loaded (/usr/lib/systemd/system/mdadm-grow-continue@.service; static)
   Active: failed (Result: exit-code) since Tue 2015-05-26 05:33:59 EDT; 21s ago
  Process: 5374 ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I (code=exited, status=1/FAILURE)
 Main PID: 5374 (code=exited, status=1/FAILURE)

May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: Started Manage MD Reshape on /dev/md0.
May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: mdadm-grow-continue@md0.service: main process exited, ...URE
May 26 05:33:59 intel-waimeabay-hedt-01.lab.eng.rdu.redhat.com systemd[1]: Unit mdadm-grow-continue@md0.service entered failed state.
Hint: Some lines were ellipsized, use -l to show in full.
[root@intel-waimeabay-hedt-01 create_assemble]# mdadm --grow --continue /dev/md0 --backup-file=tmp0
mdadm: Need to backup 6144K of critical section..

Now the reshape start. 

   
> 
> 
> > 
> > 
> >    And if it want to set sync_max to 0 until the backup has been taken. Why
> >    does not
> > set sync_max to 0 directly, but use the value reshape_progress? There is a
> > little confused.
> 
> When reshaping an array to a different array of the same size, such as a
> 4-driver RAID5 to a 5-driver RAID6, then mdadm needs to backup, one piece at
> a time, the entire array (unless it can change data_offset, which is a
> relatively new ability).
> 
> If you stop an array when it is in the middle of such a reshape, and then
> reassemble the array, the backup process need to recommence where it left
> off.
> So it tells the kernel that the reshape can progress as far as where it was
> up to before.  So 'sync_max' is set based on the value of 'reshape_progress'.
> (This will happen almost instantly).
> 
> Then the background mdadm (or the mdadm started by systemd) will backup the
> next few stripes, update sync_max, wait for those stripes to be reshaped,
> then
> discard the old backup, create a new one of the few stripes after that, and
> continue.
> 
> Does that make it a little clearer?

This is a big dinner for me. I need digest this for a while. Thanks very much
for this. What's the "backup process"?

Could you explain backup in detail. I read the man about backup file.

When  relocating the first few stripes on a RAID5 or RAID6, it is not possible to keep the data on disk completely
consistent and crash-proof.  To provide the required safety, mdadm disables writes to the array while this "critical  
section"  is reshaped, and takes a backup of the data that is in that section.  

What's the reason about data consistent when relocate data? 

> 
> And in response to your other email:
> >     Does it should return 1 when pid > 0 and status is not zero?
> 
> No.  continue_via_systemd should return 1 precisely when the 'systemctl'
> command was successfully run.  So 'status' must be zero.
> 
> 

I got this. So reshape_array should return when continue_via_systemd return 1. Then the
reshape is going on when run the command mdadm --grow --continue. Now the child_monitor
is called and sync_max is set to max.

Best Regards
Xiao


