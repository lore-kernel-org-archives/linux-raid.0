From: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Subject: mdadm-3.2.5: segfault in "--grow --continue"
Date: Tue, 10 Jul 2012 12:46:19 +0200
Message-ID: <D6EAEC68-9C5B-4CBF-943C-85ABF3E319BD@tu-dresden.de>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi!

I had to shut down a server with a raid grow operation (cleanly). After some hassles I got the array assembled again (manually), but it would not continue to grow. When trying 

mdadm --grow --continue /dev/md127 

(as per the manpage) I receive a segfault. Compiling from source, and using gdb, I see:

root@kuiper:~/mdadm-3.2.5# gdb ./mdadm 
[SNIP]
Reading symbols from /root/mdadm-3.2.5/mdadm...done.
(gdb) set args --grow --continue /dev/md127 
(gdb) run 
Starting program: /root/mdadm-3.2.5/mdadm --grow --continue /dev/md127 

Program received signal SIGSEGV, Segmentation fault.
Grow_continue_command (devname=0x7fffffffe8cc "/dev/md127", fd=7, backup_file=0x0, verbose=0) at Grow.c:4118
4118		if (verify_reshape_position(content,
(gdb) bt
#0  Grow_continue_command (devname=0x7fffffffe8cc "/dev/md127", fd=7, backup_file=0x0, verbose=0) at Grow.c:4118
#1  0x0000000000407ac2 in main (argc=4, argv=0x7fffffffe678) at mdadm.c:1701



The same bug is present in the git repository, but another location:

root@kuiper:~/mdadm.git# gdb ./mdadm 
[SNIP]
Reading symbols from /root/mdadm.git/mdadm...done.
(gdb) set args --grow --continue /dev/md127 
(gdb) run 
Starting program: /root/mdadm.git/mdadm --grow --continue /dev/md127 

Program received signal SIGSEGV, Segmentation fault.
Grow_continue_command (devname=0x7fffffffe8d0 "/dev/md127", fd=7, backup_file=0x0, verbose=0) at Grow.c:4086
4086		if (verify_reshape_position(content,
(gdb) bt
#0  Grow_continue_command (devname=0x7fffffffe8d0 "/dev/md127", fd=7, backup_file=0x0, verbose=0) at Grow.c:4086
#1  0x0000000000406c39 in main (argc=4, argv=0x7fffffffe678) at mdadm.c:1447


I also filed a bug against Debian's BTS, but I did not receive a bug number yet. In the meantime, I'd be very happy about any information on how to get my RAID array back into growing. I'm not on the list, please CC me.

Thanks.
Sebastian