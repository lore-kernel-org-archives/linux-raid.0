From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Is it possible to create a raid from/over other raids?
Date: Wed, 18 Dec 2013 21:12:30 +0000
Message-ID: <BLU0-SMTP2702D8075688EF7D229D66498DA0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I realise if it is possible its not going to be the best solution, but a
temp stop gap... 

What I am thinking of doing is while I save up to by my 4'th new disk
for a new raid 6 setup (4 drive raid 6, currently has 3 disks 1 missing)
is it possible to use 3 existing smaller disks, create a raid0 across
them and then add the resulting /dev/dmX as "a disk" where the currently
missing disk is marked as missing.

EG. /dev/md7  ... /dev/sdb1 /dev/sdc1 /dev/sdd1 missing

mdadm create /dev/md8 raid0 /dev/sde1 /dev/sdf1 /dev/sdg1

mdadm --add /dev/md7 /dev/md8

If it is possible do I need to make sure the order in the conf file
first lists the /md8 then the /md7 or will mdadm see that a raid
contains a raid as a disk and then waits for it before assembling.

  

