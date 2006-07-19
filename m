From: Alex Davis <alex14641@yahoo.com>
Subject: Is it possible to recover data after resync?
Date: Wed, 19 Jul 2006 11:40:48 -0700 (PDT)
Message-ID: <20060719184048.96988.qmail@web50204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Situation:

I accidentally killed the power to my 5-disk RAID 5 array. I then powered
it back up and rebooted the system. After reboot, however, I got the follow-
ing error when trying to assemble the array:

mdadm -A -amd /dev/md0 /dev/sd[a-e]
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.

I had read somewhere that it's possible to recover an array using the -C
option to mdadm. Unfortunately, I didn't specify 'missing', so instead of
recovering, it's resyncing. 

Is there any way to recover the original data?

I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
