From: "Doug Griswold" <griswld@cio.sc.gov>
Subject: md multipath w/ 2 hba's
Date: Tue, 09 Sep 2003 14:14:07 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <sf5de036.073@gw.state.sc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't know if this is exactly the right place to ask this question,
but here it goes.  I have installed 2 emulex hbas in a red hat as2.1
server.  I first saw duplicate paths to each lun.  Now I am trying to
get failover paths to work so if one path goes down the other will pick
up.  What I am seeing is the path to /dev/sdj is the only one working. 
What I have done so far is edited my /etc/raidtab and put this entry in

raiddev /dev/md0
raid-level      multipath
nr-raid-disks   2
chunk-size      4 
persistent-superblock 1
device          /dev/sdb
raid-disk       0
device          /dev/sdj
raid-disk       1


1.  I then issued mkraid /dev/md0
2.  Made filesystem
3.  edited fstab and mounted the filesystem but I don't have failover.

Here is my output from /proc/mdstat


md0 : active multipath sdj[0] sdb[1]
      14226368 blocks [1/1] [U]



Is what I'm trying to do feasible or am I completely off track here. 
If I am on track what have I missed.  


Thanks,
Doug
