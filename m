From: Ming Zhang <mingz@ele.uri.edu>
Subject: consistency detect
Date: Sun, 10 Oct 2004 23:32:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097465522.3111.24.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a question on RAID error detect. hope somebody can help me to
find it out. thanks.

take raid1 as an example, if one disk fail, raid 1 can detect the data
on disk is compromised and then reconstruct it using a spare disk. this
is straight forward.

but if one request comes to raid1 and raid1 sends requests to both
disks, at this time, system reboots because power outage, system
crashes, or any other reason. then after system reboots, how raid 1
detects which disk has consistent data? since before reboot, anything
can happen, data may in disk1 but not in disk2, or in disk2 but not in
disk1, or not in both disks, or already on both disks.

how raid1 or other raid code deal with this?


ming


-- 
 --------------------------------------------------
| Ming Zhang, PhD. Student
| Dept. of Electrical & Computer Engineering
| College of Engineering
| University of Rhode Island
| Kingston RI. 02881
| e-mail: mingz at ele.uri.edu
| Tel. (401) 874-2293 
| Fax. (401) 782-6422
| http://www.ele.uri.edu/~mingz/
| http://crab.ele.uri.edu/gallery/albums.php
 --------------------------------------------------


