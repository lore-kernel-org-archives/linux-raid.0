From: Janek Kozicki <janek_listy@wp.pl>
Subject: doesm mdadm try to use fastest HDD ?
Date: Fri, 2 Nov 2007 12:52:05 +0100
Message-ID: <20071102125205.52c2d115@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

My three HHDs have following speeds:

  hda - speed 70 MB/sec
  hdc - speed 27 MB/sec
  sda - speed 60 MB/sec

They create a raid1 /dev/md0 and raid5 /dev/md1 arrays. I wanted to
ask if mdadm is trying to pick the fastest HDD during operation?

Maybe I can "tell" which HDD is preferred?

This came to my mind when I saw this:

  # mdadm --query --detail /dev/md1 | grep Prefer
 
  Preferred Minor : 1

And also in the manual:

  -W, --write-mostly [...] "can be useful if mirroring over a slow link."


many thanks for all your help!
-- 
Janek Kozicki                                                         |
