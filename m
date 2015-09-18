From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: strange syslog message on daily mdadm cron job
Date: Fri, 18 Sep 2015 15:57:50 +0200
Message-ID: <20150918155750.Horde.pf92hY6SXyDte5eXjR1cG6R@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi *,

checking syslog I noticed the following messages, created on openSUSE  
13.1 during each daily "mdadm" cron job:

--- cut here ---
mdadm[15265]: DeviceDisappeared event detected on md device  
/dev/md/host01-data
mdadm[15265]: DeviceDisappeared event detected on md device  
/dev/md/host01-cache
mdadm[15265]: NewArray event detected on md device /dev/md127
mdadm[15265]: NewArray event detected on md device /dev/md126
--- cut here ---

The command issued by the cron job is

eval /sbin/mdadm -F --oneshot --syslog -m "user@company.com" -s -c  
"/etc/mdadm.conf"

The contents of /etc/mdadm.conf are

--- cut here ---
DEVICE containers partitions
ARRAY /dev/md/host01-cache UUID=3884ea75:28c82f09:05d0026d:1c95b268
ARRAY /dev/md/host01-data UUID=92a1b47d:6c889735:6d60a23f:f8d8067c

HOMEHOST host01
MAILADDR user@company.com
MAILFROM host01@company.com
--- cut here ---

Searching the net didn't pop up any obvious hints, but shows several  
responses to problem reports that advice to leave mdadm.conf empty.

We do not experience any noticeable problems, nor does mdadm send any  
error report emails. The latter is tested, we had reports of faulty  
disks some time ago (related to controller problems, not actual disk  
errors). "mdadm --detail" reports look perfectly fine for both arrays.

Are the syslog messages the result of a local configuration error, or  
may there be some other cause?

Regards,
Jens

