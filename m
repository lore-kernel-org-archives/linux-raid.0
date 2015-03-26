From: Xiao Ni <xni@redhat.com>
Subject: Re: /dev/md0 can't be created
Date: Thu, 26 Mar 2015 03:36:35 -0400 (EDT)
Message-ID: <200110393.3671122.1427355395924.JavaMail.zimbra@redhat.com>
References: <1215809785.2787621.1427263359309.JavaMail.zimbra@redhat.com> <12135556.2792023.1427264134774.JavaMail.zimbra@redhat.com> <20150325173529.13a6efd7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150325173529.13a6efd7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

   I can reproduce it now. Do you want me to run udevadm monitor before the test?
And I checked the /var/log/messages, it show the information:

Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-2>
Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-3>
Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-4>
Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-5>
Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-6>
Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-7>
Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-9>
Oct 20 19:59:59 ibm-z10-25 kernel: md: bind<dm-8>
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-7 operational as raid disk 5
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-6 operational as raid disk 4
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-5 operational as raid disk 3
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-4 operational as raid disk 2
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-3 operational as raid disk 1
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: device dm-2 operational as raid disk 0
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: allocated 0kB
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid:md0: raid level 5 active with 6 out of 7 devices, algorithm 2
Oct 20 19:59:59 ibm-z10-25 kernel: md/raid456: discard support disabled due to uncertainty.
Oct 20 19:59:59 ibm-z10-25 kernel: Set raid456.devices_handle_discard_safely=Y to override.
Oct 20 19:59:59 ibm-z10-25 kernel: md0: detected capacity change from 0 to 1881145344
Oct 20 19:59:59 ibm-z10-25 kernel: md: recovery of RAID array md0
Oct 20 19:59:59 ibm-z10-25 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Oct 20 19:59:59 ibm-z10-25 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Oct 20 19:59:59 ibm-z10-25 kernel: md: using 128k window, over a total of 306176k.
Oct 20 19:59:59 ibm-z10-25 systemd-udevd: inotify_add_watch(7, /dev/md0, 10) failed: No such file or directory
  
Xiao

----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Wednesday, March 25, 2015 2:35:29 PM
> Subject: Re: /dev/md0 can't be created
> 
> On Wed, 25 Mar 2015 02:15:34 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> > Hi all
> > 
> >    I have encountered so many times, the raid device is created
> >    successfully, but the directory
> > /dev/md0 can't be created. It can't reproduce 100%.
> > 
> > [root@intel-sugarbay-do-01 create_assemble]# cat /proc/mdstat
> > Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> > md0 : active raid10 loop7[7](S) loop6[6] loop5[5] loop4[4] loop3[3]
> > loop2[2] loop1[1] loop0[0]
> >       1788416 blocks super 1.2 512K chunks 2 near-copies [7/7] [UUUUUUU]
> >       bitmap: 0/1 pages [0KB], 65536KB chunk
> > 
> > unused devices: <none>
> > [root@intel-sugarbay-do-01 create_assemble]# ls /dev/md0
> > ls: cannot access /dev/md0: No such file or directory
> > 
> >     The underline devices are loop devices which are created with big file.
> > 
> >     The kernel I used is RHEL7 (3.10.0-234.el7.x86_64.debug, mdadm - v3.3.2
> >     - 21st August 2014)
> > I'll try to reproduce this with upstream kernel and mdadm. But I think it
> > shouldn't be the problem about kernel.
> > 
> >     What do you think I should check for this? And which tool is
> >     responsible for creating the directory? Maybe
> > I can add some log to it to find the reason.
> > 
> 
> /dev/md0 is created by udev.
> Run
>   udevadm monitor
> 
> to see the events that udev is processing.  When and ADD event for "md0" is
> processed, /dev/md0 should get created.
> 
> NeilBrown
> 
