From: Bruno Kropp <bruno.kropp@denken.it>
Subject: nbd and raid devices problems
Date: Tue, 3 Sep 2002 16:57:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200209031657.00991.bruno.kropp@denken.it>
Reply-To: bruno.kropp@denken.it
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good evening,

I have problems using RAID5 (md) over nbd. 

my setup is:

host 1 (front end):
Kernel 2.4.18 
nbd-client  (nbd 2.0 from nbd-2.0.tar.gz)
RAID5 (md0) over 3 /dev/nd(x)  
|	|	|
|	|	|
|	|	host 4 (node1):
|	|	Kernel 2.4.18 
|	|	nbd-server  (nbd 2.0 from nbd-2.0.tar.gz)
|	|
|	|
|	|
|	host 3 (node1):
|	Kernel 2.4.18 
|	nbd-server  (nbd 2.0 from nbd-2.0.tar.gz)
|
host 2 (node0):
Kernel 2.4.18 
nbd-server  (nbd 2.0 from nbd-2.0.tar.gz)


Everything seems to be ok, I can startup the nbd-client/server, I can build 
the RAID5, I can create Filesystem on the md, I can mount, I can Write/Read 
on it...

But, when disconnecting a network link from nbd server (is not relevant if 
host 2,3 or 4) all process on host 1 in I/O over md0 remain hang in D state 
for 15 minutes...

After this timeout, the host 1 declare the raidset degraded and all is ok 
again...

I have already tried to modify /proc/sys/net/ipv4/tcp_keepalive_xxxxx 
(thinking the problem to be related to socket or TCP keepalive) but all 
remain the same: 15 minutes in D state...

The same problems on a single block device mounted as simple file system 
(without RAID).

Is there any workaround?

Thanks in advance for your help

Best Regards

Bruno Kropp

