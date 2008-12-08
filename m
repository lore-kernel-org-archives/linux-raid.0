From: Michael Brancato <mike@mikebrancato.com>
Subject: status of raid 4/5 disk reduce
Date: Mon, 08 Dec 2008 15:59:01 -0500
Message-ID: <493D8A95.2020700@mikebrancato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm curious as to the status of the ability to reduce the number of 
disks in a RAID 4/5 array.  I would like the ability to reshape a 4 disk 
raid4/5 to a 3 disk raid4/5 for flexibility.

here is what I want to do....
$ sudo mdadm /dev/md0 --fail /dev/disk4 --remove /dev/disk4
mdadm: set /dev/disk4 faulty in /dev/md0
mdadm: hot removed /dev/disk4
$ sudo mdadm --grow /dev/md0 -n3
mdadm: /dev/md0: Cannot reduce number of data disks (yet).

I know this capability is missing in the md driver.  What is needed to 
make it work and is anyone currently working on it?

Regards,

-- 
Mike Brancato, CISSP
