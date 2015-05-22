From: Xiao Ni <xni@redhat.com>
Subject: Re: raid5 reshape is stuck
Date: Fri, 22 May 2015 04:54:39 -0400 (EDT)
Message-ID: <518629901.2912681.1432284879893.JavaMail.zimbra@redhat.com>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com> <2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com> <20150521094837.6a2d29c4@notabene.brown> <1552584910.2141570.1432179477679.JavaMail.zimbra@redhat.com> <1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: "NeilBrown" <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Sent: Thursday, May 21, 2015 8:31:58 PM
> Subject: Re: raid5 reshape is stuck
> 
> 
> 
> ----- Original Message -----
> > From: "Xiao Ni" <xni@redhat.com>
> > To: "NeilBrown" <neilb@suse.de>
> > Cc: linux-raid@vger.kernel.org
> > Sent: Thursday, May 21, 2015 11:37:57 AM
> > Subject: Re: raid5 reshape is stuck
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "NeilBrown" <neilb@suse.de>
> > > To: "Xiao Ni" <xni@redhat.com>
> > > Cc: linux-raid@vger.kernel.org
> > > Sent: Thursday, May 21, 2015 7:48:37 AM
> > > Subject: Re: raid5 reshape is stuck
> > > 
> > > On Fri, 15 May 2015 03:00:24 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> > > 
> > > > Hi Neil
> > > > 
> > > >    I encounter the problem when I reshape a 4-disks raid5 to raid5. It
> > > >    just
> > > >    can
> > > > appear with loop devices.
> > > > 
> > > >    The steps are:
> > > > 
> > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm -CR /dev/md0 -l5 -n5
> > > > /dev/loop[0-4]
> > > > --assume-clean
> > > > mdadm: /dev/loop0 appears to be part of a raid array:
> > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > mdadm: /dev/loop1 appears to be part of a raid array:
> > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > mdadm: /dev/loop2 appears to be part of a raid array:
> > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > mdadm: /dev/loop3 appears to be part of a raid array:
> > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > mdadm: /dev/loop4 appears to be part of a raid array:
> > > >        level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
> > > > mdadm: Defaulting to version 1.2 metadata
> > > > mdadm: array /dev/md0 started.
> > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm /dev/md0 -a /dev/loop5
> > > > mdadm: added /dev/loop5
> > > > [root@dhcp-12-158 mdadm-3.3.2]# mdadm --grow /dev/md0 --raid-devices 6
> > > > mdadm: Need to backup 10240K of critical section..
> > > > [root@dhcp-12-158 mdadm-3.3.2]# cat /proc/mdstat
> > > > Personalities : [raid6] [raid5] [raid4]
> > > > md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1]
> > > > loop0[0]
> > > >       8187904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]
> > > >       [UUUUUU]
> > > >       [>....................]  reshape =  0.0% (0/2046976)
> > > >       finish=6396.8min
> > > >       speed=0K/sec
> > > >       
> > > > unused devices: <none>
> > > > 
> > > >    It because the sync_max is set to 0 when run the command --grow
> > > > 
> > > > [root@dhcp-12-158 mdadm-3.3.2]# cd /sys/block/md0/md/
> > > > [root@dhcp-12-158 md]# cat sync_max
> > > > 0
> > > > 
> > > >    I tried reproduce with normal sata devices. The progress of reshape
> > > >    is
> > > >    no problem. Then
> > > > I checked the Grow.c. If I use sata devices, in function reshape_array,
> > > > the
> > > > return value
> > > > of set_new_data_offset is 0. But if I used loop devices, it return 1.
> > > > Then
> > > > it call the function
> > > > start_reshape.
> > > 
> > > set_new_data_offset returns '0' if there is room on the devices to reduce
> > > the
> > > data offset so that the reshape starts writing to unused space on the
> > > array.
> > > This removes the need for a backup file, or the use of a spare device to
> > > store a temporary backup.
> > > It returns '1' if there was no room for relocating the data_offset.
> > > 
> > > So on your sata devices (which are presumably larger than your loop
> > > devices)
> > > there was room.  On your loop devices there was not.
> > > 
> > > 
> > > > 
> > > >    In the function start_reshape it set the sync_max to
> > > >    reshape_progress.
> > > >    But in sysfs_read it
> > > > doesn't read reshape_progress. So it's 0 and the sync_max is set to 0.
> > > > Why
> > > > it need to set the
> > > > sync_max at this? I'm not sure about this.
> > > 
> > > sync_max is set to 0 so that the reshape does not start until the backup
> > > has
> > > been taken.
> > > Once the backup is taken, child_monitor() should set sync_max to "max".
> > > 
> > > Can you  check if that is happening?
> > > 
> > > Thanks,
> > > NeilBrown
> > > 
> > > 
> > 
> >   Thanks very much for the explaining. The problem maybe is fixed. I tried
> >   reproduce this with newest
> > kernel and newest mdadm. Now the problem don't exist. I'll do more tests
> > and
> > give the answer above later.
> > 
> 
> Hi Neil
> 
>    As you said, it doesn't enter child monitor. The problem still exist.
> 
> The kernel version :
> [root@intel-canoepass-02 tmp]# uname -r
> 4.0.4
> 
> mdadm I used is the newest git code from git://git.neil.brown.name/mdadm.git
> 
>    
>    In the function continue_via_systemd the parent find pid is bigger than 0
>    and
> status is 0. So it return 1. So it have no opportunity to call child_monitor.

    Does it should return 1 when pid > 0 and status is not zero?

diff --git a/Grow.c b/Grow.c
index 44ee8a7..e96465a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2755,7 +2755,7 @@ static int continue_via_systemd(char *devnm)
      break;
   default: /* parent - good */
      pid = wait(&status);
-     if (pid >= 0 && status == 0)
+     if (pid >= 0 && status != 0)
         return 1;
   }   
   return 0;

> 
> 
>    And if it want to set sync_max to 0 until the backup has been taken. Why
>    does not
> set sync_max to 0 directly, but use the value reshape_progress? There is a
> little confused.
> 
> Best Regards
> Xiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
