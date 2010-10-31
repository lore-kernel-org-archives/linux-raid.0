From: Florian Dazinger <flockmock@gmail.com>
Subject: reshape success story
Date: Sun, 31 Oct 2010 14:41:12 +0100
Message-ID: <AANLkTinnaRECf9grA6-VEAg7YNvN6M4cHWKBYsfj4v6B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
because there are so many "help"/"didn't work" mails here, I want to
give positive feedback:

Reshape of a 4-disk RAID6 (250GB each) to RADI5 worked perfectly, now
having a 3-disk RAID5 + hot spare.
the backup-file was on a NFS4-share ;)
duration: ca. 26h (cannot say for sure, it finished during night)

alas, I'm not able to tell the max. filesize of the backup-file (mdadm
deletes it afterwards), but when I looked at it in the middle of the
process, it was about 30MB. Unlike what I excpected from the man-page,
I had network traffic during the *whole* reshape-process, not just at
the beginning. It would be interesting to know, how fast the reshape
process would have been, if the backup-file were on a local disk...

kernel-2.6.36
mdadm-3.1.4

thank you very much for all the good work and user support on this list!!
cheers, florian
