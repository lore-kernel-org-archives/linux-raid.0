From: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.ac.be>
Subject: what happens to raid when more disks are added?
Date: Wed, 07 May 2003 17:44:03 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB929C3.6040400@cc.kuleuven.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I currently have two systems using "standard" sw raid, and 2 more to set 
up (hopefully using mdadm).
Their data disks are located in a splitbus PowerVault and mirrored 
across scsi adapters  Adapter 1 connects to disks in slots 0, 1, and 2 
in the PowerVault, adapter 2 connects to disks in slots 9, 10, and 11.

To linux, they are known as devices sd[c-h], which have been configured 
as raid 0+1:

# cat /proc/mdstat
Personalities : [raid0] [raid1]
read_ahead 1024 sectors
md2 : active raid1 md1[1] md0[0]
      106679168 blocks [2/2] [UU]

md0 : active raid0 sde1[2] sdd1[1] sdc1[0]
      106679232 blocks 8k chunks

md1 : active raid0 sdh1[2] sdg1[1] sdf1[0]
      106679232 blocks 8k chunks

unused devices: <none>

When I need to add extra disks, e.g. in slots 3 and 12, I assume that 
the disk in slot 3 will get device name /dev/sdf, and the disks in slots 
9 through 12 will subsequently be known as /dev/sd[g-j].  How will that 
affect the raid 0+1 config?

Kind regards,

Herta

