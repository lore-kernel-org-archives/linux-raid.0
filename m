From: AndyLiebman@aol.com
Subject: Segmentation Fault on Raidstop
Date: Fri, 31 Oct 2003 11:59:01 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <17a.21dfdbd2.2cd3eed5@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 just created a RAID 10 array -- a RAID 0 array on top of three RAID 1 pairs. 

I did mkraid --really-force /dev/mdX for each of the RAID 1 arrays (md0, md1, 
md2). When I created my RAID 0 (md3), I realized I had forgotten to specify 
persistent superblock 1 in raidtab. 

So, I went to stop md3 (raidstop /dev/md3) so that I could remake it and I 
got a "segmentation fault" error. 

Does anybody know how to correct this problem? 
