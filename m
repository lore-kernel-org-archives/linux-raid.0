From: Stephen C Woods <scw@seas.ucla.edu>
Subject: How to force raid to stop, cleanly? More info
Date: Tue, 8 Apr 2003 15:29:51 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304082229.PAA04958@washington.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>   We're running 2.4.20,  we've come across a situation where the 
>raid and overlying LVM seems to be stuck.  No I/O is occuring, processes
>trying to access to raid or overlying volumes hang and can't be
>terminated.
>
>   What we'd like to do is to force the raid volume to terminate
>and sync its disks and superblocks, so that the raid volume is
>or thinks it is consistant.
>
> The overlying JFS will clean up when it restarts, but we don't want to
>wait 3 days for the RAID to finish recomputing parity (these are some really
>large arrays).

  Here's a little more info. 
(1)The scsi disks are responding correctly,  I can read from each drive.  
(2) More processes are getting stuck, lilo, sync and mkdir
(3) There are 2 processes stuck on rwsem_down_failed both related to
    the raid/lvm.
(3) mdadm thinks the everything is just fine.

Current ps output.
  PID STAT %CPU  WCHAN WIDE-WCHAN-COLUMN COMMAND,wchan=WIDE-WCHAN-COLUMN -o arg 
    1 S     0.0 14af8d do_select         init [3] 
    2 SW    0.0 127efd context_thread    [keventd]
    3 SW    0.0 11566a apm_mainloop      [kapmd]
    4 SWN   0.0 11f30e ksoftirqd         [ksoftirqd_CPU0]
    5 SW    0.1 133806 kswapd            [kswapd]
    6 SW    0.0 13fe2a bdflush           [bdflush]
    7 DW    0.1 a2a048 end               [kupdated]
    8 SW<   0.0 1ebfb5 md_thread         [mdrecoveryd]
   12 SW    0.0 81cb6c end               [kjournald]
   68 SW    0.0 83d52e end               [khubd]
  168 SW    0.0 81cb6c end               [kjournald]
  169 SW    0.0 81cb6c end               [kjournald]
  170 SW    0.0 81cb6c end               [kjournald]
  171 SW    0.0 81cb6c end               [kjournald]
  465 S     0.0 14af8d do_select         syslogd -m 0
  469 S     0.0 11a3d1 do_syslog         klogd -x
  486 S     0.0 14b716 do_poll           portmap
  505 S     0.0 14af8d do_select         rpc.statd
  586 S     0.0 14af8d do_select         /usr/sbin/apmd -p 10 -w 5 -W -P /etc/sy
  602 S     0.0 14b716 do_poll           ypserv
  614 S     0.0 14b716 do_poll           ypbind
  661 S     0.0 14af8d do_select         /usr/sbin/sshd
  675 S     0.0 14af8d do_select         xinetd -stayalive -reuse -pidfile /var/
  686 SL    0.0 14af8d do_select         ntpd -U ntp -g
  705 S     0.0 14b716 do_poll           rpc.rquotad
  709 SW    0.0 95bf32 end               [nfsd]
  710 SW    0.0 95bf32 end               [nfsd]
  711 SW    0.0 95bf32 end               [nfsd]
  712 SW    0.0 95bf32 end               [lockd]
  713 SW    0.0 95845e end               [rpciod]
  714 SW    0.0 95bf32 end               [nfsd]
  715 SW    0.0 95bf32 end               [nfsd]
  716 SW    0.0 95bf32 end               [nfsd]
  717 SW    0.0 95bf32 end               [nfsd]
  718 SW    0.0 95bf32 end               [nfsd]
  724 S     0.0 14b716 do_poll           rpc.mountd
  733 S     0.0 14af8d do_select         gpm -t ps/2 -m /dev/mouse
  742 S     0.0 1231e3 nanosleep         crond
  771 S     0.0 14af8d do_select         xfs -droppriv -daemon
  789 S     0.0 1231e3 nanosleep         /usr/sbin/atd
  802 S     0.0 1231e3 nanosleep         rhnsd --interval 120
  806 S     0.0 177e9d read_chan         /sbin/mingetty tty1
  807 S     0.0 177e9d read_chan         /sbin/mingetty tty2
  808 S     0.0 177e9d read_chan         /sbin/mingetty tty3
  809 S     0.0 177e9d read_chan         /sbin/mingetty tty4
  810 S     0.0 177e9d read_chan         /sbin/mingetty tty5
  811 S     0.0 177e9d read_chan         /sbin/mingetty tty6
  856 SW<   1.5 1ebfb5 md_thread         [raid5d]
  857 SWN   0.1 1ebfb5 md_thread         [raid5syncd]
  882 SW    0.0 a297cb end               [jfsIO]
  883 DW    0.0 24aa8c rwsem_down_failed [jfsCommit]
  884 SW    0.0 a2d7cd end               [jfsSync]
 1669 SW<   2.2 1ebfb5 md_thread         [raid5d]
 1670 SWN   0.5 1ebfb5 md_thread         [raid5syncd]
24442 DN    0.0 a2a048 end               rsync -avHx . /vg00/raid0/topanga/icsl.
24445 DN    0.0 a2a048 end               rsync -avHx . /vg00/raid1/topanga/ee.05
24500 DN    1.1 a2a048 end               rsync -avHx . /vg00/raid0/topanga/icsl.
24501 DN    0.8 24aa8c rwsem_down_failed rsync -avHx . /vg00/raid1/topanga/ee.05
26064 D     0.0 a2a048 end               mkdir topanga.030408
26110 D     0.0 107c4a down              ls
26116 D     0.0 a2a048 end               sync
26672 S     0.0 14af8d do_select         in.rlogind
26673 S     0.0 11da20 wait4             login -- root
26674 S     0.0 177e9d read_chan         -bash
26773 D     0.0 15011b wait_on_inode     lilo
26840 D     0.0 15011b wait_on_inode     lilo
26857 S     0.0 14af8d do_select         in.rlogind
26858 S     0.0 11da20 wait4             login -- root
26859 S     0.0 11da20 wait4             -bash


-----
Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
Unless otherwise noted these statements are my own, Not those of the 
University of California.                      Internet mail:scw@seas.ucla.edu
