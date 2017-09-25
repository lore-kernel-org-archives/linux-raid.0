From: Xuesong LU <disluxs@nus.edu.sg>
Subject: Need Help for Raid Recovery
Date: Mon, 25 Sep 2017 15:53:05 +0800
Message-ID: <ccba6492-26b7-c084-aa1e-6d69c7f48785@nus.edu.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

One of the raid devices on my server could not assemble after server
reboot.  The raid is level 6 assembled using partition sdg1~sdp1, 10
disks in total. Below is what I have done to the issue.

1) mdadm --examine /dev/sd[g-p]1. All event counts are the same.
2) mdadm --assemble /dev/md0 /dev/sd[g-p]1. It read 'md0 is started',
then the server rebooted itself. However, the server got stuck for one
hour at the centos 7 loading bar screen.
3) I forced shutdown and restarted the server. This time --examine said
'couldn't find superblocks on sdg1'. Also partition file sdk1, sdo1 and
sdp1 disappeared. I guess this is because I forced shutdown?

More details are here.

cat /proc/mdstat shows only md1, where is another raid device. However,
what I want to recover is /dev/md0.

mdadm --assemble /dev/md0 /dev/sd[g-p]1 says 'only six drives found' so
cannot assemble.

mdadm --examine /dev/sd[g-p] prints raid partition information for
sd[h,i,j,l,m,n]. No superblock detected on sd[g,k,o,p].

mdadm --examine /dev/sd[g-p]1 prints raid partition information for
sd[h,i,j,l,m,n]1. The event counts are the same. It also prints 'No
superblock detected' for sdg1, and 'no such files' for sd[k,o,p]1.
(Gone? Can still recover?)

I have UUID for md0 in the mdadm.conf file.

Is there still hope to recover my raid? Thank you!

--
Best,
Xuesong


________________________________

Important: This email is confidential and may be privileged. If you are not the intended recipient, please delete it and notify us immediately; you should not copy or use it for any purpose, nor disclose its contents to any other person. Thank you.
