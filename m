From: Sevatio <sevatio@atella.com>
Subject: Kicking Non-Fresh From Array
Date: Thu, 20 May 2004 13:40:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40AD17C1.8010708@atella.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can't figure out how to get a partition into a Raid1 array.  Syslog 
tells me "kicking non-fresh hdc6 from array".  Raidtab is set to assign 
/dev/hda6 & /dev/hdc6 to /dev/md1:

raiddev       /dev/md1
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hda6
     raid-disk 0
     device    /dev/hdc6
     raid-disk 1

But mdstat only shows hda6 for md1.  Also, I tried raidhotadd but it 
doesn't show hdc6 as being active:

md1 : active raid1 hdc6[1] hda6[0]
       6144704 blocks [1/1] [U]

How do I fix this to get hdc6 to join md1?

Thanks,
Sevatio
