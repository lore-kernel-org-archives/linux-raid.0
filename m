From: Jeff Hill <jhill@hronline.com>
Subject: mdadm mail option configuration
Date: Tue, 28 May 2002 12:04:00 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20020528111927.01f28280@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having problems configuring mdadm to send e-mail alerts. From past list 
discussions I configured it with:

devo:/#  cat /etc/mdadm.conf

DEVICE /dev/hd*[0-9] /dev/sd*[0-9]
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=8e0114bb:e5b3a608:048bed2d:5fe33724
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=434dd79d:0c046e9b:867e8d98:86bdb5da
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=9a9a2078:44c22d83:25a32457:db7e3783
ARRAY /dev/md5 level=raid1 num-devices=2 
UUID=e3254469:34147651:c9298800:5a84cd06
ARRAY /dev/md6 level=raid1 num-devices=2 
UUID=80c78ac7:c0f4442a:3dd6517d:57edc79e
MAILADDR jhill@hrpost.com
PROGRAM /usr/local/sbin/raidalert

------
Then, I just have an init script that runs:

	/sbin/mdadm -Fs --delay=600 &

I thought having that running would be right for monitoring and e-mailing, 
but I've tried a few variations without success. When one of the component 
devices fails and is booted out of the array, no alert is mailed. The 
raidalert script is one I picked up from past discussions on the list, and 
I wouldn't think it would be causing any problems:

devo:/#  cat /usr/local/sbin/raidalert
#!/bin/bash
# Log Raid Problems
logger -p kern.crit -t RAID $*

--------

I know this should be simple. I must be missing the obvious, but hours of 
tinkering and searching the list archives have gotten me nowhere.

Thanks for any assistance,

Jeff Hill

