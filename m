From: Florian Schanda <ma1flfs@bath.ac.uk>
Subject: 2.6.0-test{1,2,3} kernels + software raid 0 + xfs broken?
Date: Sat, 23 Aug 2003 19:16:00 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308231916.00588.ma1flfs@bath.ac.uk>
Reply-To: ma1flfs@bath.ac.uk
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am running a 2.4.21 kernel + xfs + raid0 (software) on 2 scsi disks. It 
works without flaws.

Trying the same setup in 2.6.0-test{1,2,3} (haven't tested 4 yet) _will_ give 
data corruption if I write to the array.

2 Things that happen are:
* Creating a directory and then being unable to remove it: (rm -r foo says foo 
is not directory, rmdir foo says foo is not a directory, rm foo says foo is a 
directory, ls -l foo says it is a directory)
* writing files to the array, unmount array (works fine up here), mounting 
again utterly fails. (bad superblock, etc, etc) Doing an "xfs_repair -L" will 
kill a lot of data (the files modifies / written) but fix it. Rebooting into 
2.4 will fix it too (It doesn't even complain when mounting the thing.)

Anybody has an idea?

Thanks,

	- Florian

