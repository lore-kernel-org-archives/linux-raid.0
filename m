From: Forrest Taylor <ftaylor@redhat.com>
Subject: RAID 5 Grow
Date: Fri, 15 Jul 2005 13:50:52 -0600
Message-ID: <1121457052.3012.36.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am doing some RAID scenarios on a single disc (testing purposes) on
RHEL4.  I have some partitions as follows:

/dev/hda5  100M
/dev/hda6  200M
/dev/hda7  200M
/dev/hda8  200M
/dev/hda9  200M

I create a RAID 5 set with /dev/hda{5,6,7,8}.  I fail/remove /dev/hda5
and add /dev/hda9, at which point I can grow the RAID.  Running:

mdadm -G /dev/md0 -z max

will increase the RAID size, however, it sets off a infinite resync.  I
have tested with mdadm-1.6.0-2, and with mdadm-1.12.0-1 rebuilt from the
source rpm.

Here is a snippet of the messages:

Jul 13 09:33:36 station8 kernel: md: syncing RAID array md0
Jul 13 09:33:36 station8 kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Jul 13 09:33:36 station8 kernel: md: using maximum available idle IO
bandwith (but not more than 200000 KB/sec) for reconstruction.
Jul 13 09:33:36 station8 kernel: md: using 128k window, over a total of
104320 blocks.
Jul 13 09:33:36 station8 kernel: md: resuming recovery of md0 from
checkpoint.
Jul 13 09:33:36 station8 kernel: md: md0: sync done.
Jul 13 09:33:36 station8 kernel: RAID5 conf printout:
Jul 13 09:33:36 station8 kernel:  --- rd:4 wd:4 fd:0
Jul 13 09:33:36 station8 kernel:  disk 0, o:1, dev:hda6
Jul 13 09:33:36 station8 kernel:  disk 1, o:1, dev:hda7
Jul 13 09:33:36 station8 kernel:  disk 2, o:1, dev:hda8
Jul 13 09:33:36 station8 kernel:  disk 3, o:1, dev:hda9

which print out many times per second.  I have to reboot the system to
get it to stop filling /var/log/messages.  Once it reboots, and syncs, I
don't get any problems with it.  Any idea where the problem might be?

Thanks,

Forrest

