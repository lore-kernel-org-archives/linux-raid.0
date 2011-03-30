From: hank peng <pengxihan@gmail.com>
Subject: strange problem with my raid5
Date: Wed, 30 Mar 2011 20:34:35 +0800
Message-ID: <AANLkTinEcLaQAdoFgbV6+UGkPYKTgBass8J8pUBQ3h_X@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,all:
I created a raid5 array which consists of 15 disks, before recovering
is done, a power failure event occured. After power is recovered, the
machine box started successfully but "cat /proc/mdstat" gave no
message, previously created raid5 was gone. I check kernel messages,
it is as follows:

<snip>
bonding: bond0: enslaving eth1 as a backup interface with a down link.
svc: failed to register lockdv1 RPC service (errno 97).
rpc.nfsd used greatest stack depth: 5440 bytes left
md: md1 stopped.
iSCSI Enterprise Target Software - version 1.4.1
</snip>

In normal case, md1 should bind its disks after printing "md: md1
stopped", then what happened in this cituation?
BTW, my kernel version is 2.6.31.6.


-- 
The simplest is not all best but the best is surely the simplest!
