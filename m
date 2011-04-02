From: Eugene <hdejin@yahoo.com>
Subject: mdadm 3.2.1: Segfaulting with -p
Date: Sat, 2 Apr 2011 05:28:43 -0700 (PDT)
Message-ID: <747613.94276.qm@web130110.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

/sbin/mdadm -F --scan -1 -p /etc/mdcheck.sh causes a segfault
with 3.2.1

Tested on 2.6.38.2 32-bit kernel.

GDB backtrace
Program terminated with signal 11, Segmentation fault.
#0  0xb77dba01 in __strncmp_ia32 () from /lib/libc.so.6
(gdb) bt
#0  0xb77dba01 in __strncmp_ia32 () from /lib/libc.so.6
#1  0x0806d603 in add_new_arrays (mdstat=0x80c8198, statelist=0xbf862cbc, test=0, info=0xbf862cac) at Monitor.c:691
#2  0x0806c189 in Monitor (devlist=0x0, mailaddr=0x0, alert_cmd=0xbf864cc8 "/etc/mdcheck.sh", period=1000, daemonise=0, scan=1, oneshot=1,
    dosyslog=0, test=0, pidfile=0x0, increments=20, share=1) at Monitor.c:228
#3  0x0804e275 in main (argc=6, argv=0xbf8632c4) at mdadm.c:1596

Monitor.c line 691 is doing strncmp on a NULL pointer
if (strncmp(mse->metadata_version, "external:", 9) == 0 &&
                            is_subarray(mse->metadata_version+9))
                                st->parent_dev =


Regards,
Eugene

