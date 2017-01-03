From: Hans Kraus <hans@hanswkraus.com>
Subject: mdadm: no more mails during monthly scrubbing under Jessie
Date: Tue, 3 Jan 2017 13:55:18 +0100
Message-ID: <c2b5cf99-906a-acfe-1a4a-354fb740a8f9@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I recently upgrades my Debian sever from Wheezy to Jessie.

I have the standard configuration, especially the monthly ckeck via the
cron entry: "57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] &&
[ $(date +\%d) -le 7 ]; then /usr/share/mdadm/checkarray --cron --all
--idle --quiet; fi".

Under Wheezy I got progress mails like:
-------------------------------------------------------------------------
MD Device: /dev/md/robbe:storage
Event: Rebuild60

/proc/mdstat:
Personalities : [raid6] [raid5] [raid4]
md127 : active raid6 sdk1[0] sde1[9] sdi1[8] sdf[7] sdj1[5] sdg1[4] sdh1[6]
       19534426880 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[7/7] [UUUUUUU]
       [============>........]  check = 60.9% (2381950248/3906885376) 
finish=259.5min speed=97924K/sec
       Action ready: 2016-04-03 12:13:13.949761

unused devices: <none>
-------------------------------------------------------------------------
from mdadm system.

I do not get these mails any more. Extensive googling brought nothing
except some users complaining about theese mails ...

How do I enable theese mails again? I like them as security info that
all is well with my Raid.

Kind regards,
Hans

