From: Jeff Byrkit <jbyrkit@pcpao.org>
Subject: mdadm and --program
Date: Thu, 3 Oct 2002 16:01:35 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210031601.35139.jbyrkit@pcpao.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I want to use mdadm to email me with all of the events, not just the Fail and 
FailSpare events. So I need to use --program. On another terminal, I fail, 
remove, and add one of the raid5 disks. I try using mdadm like this:

# mdadm --follow --program /etc/handle-mdadm-events  --delay 1 /dev/md0

where handle-mdadm-events is (culled from previous posts):

echo $*
logger -p kern.crit -t RAID $*

but I never get anything at my terminal or in the log. If I don't use the 
--program, it gives me:


linuxsc:/home/pcpao # mdadm --follow  --delay 1 /dev/md0
Oct  3 09:47:52: FailSpare on /dev/md0 /dev/sdf

anyone have any ideas? can I do --program "echo $*" ? just to get it to do 
something?

linuxsc:/etc # cat /proc/version
Linux version 2.4.18-64GB-SMP (root@SMP_X86.suse.de) (gcc version 2.95.3 
20010315 (SuSE)) #1 SMP Wed Mar 27 13:58:12 UTC 2002


jeff b

