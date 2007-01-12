From: Ernst Herzberg <earny@net4u.de>
Subject: Re: FailSpare event?
Date: Fri, 12 Jan 2007 15:34:15 +0100
Message-ID: <200701121534.17618.earny@net4u.de>
References: <eo6cn8$5se$1@sea.gmane.org> <17830.47341.560158.521091@notabene.brown>
Reply-To: earny@net4u.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17830.47341.560158.521091@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 11 January 2007 23:23, Neil Brown wrote:
> On Thursday January 11, mikee@mikee.ath.cx wrote:
> > Can someone tell me what this means please? I just received this in
> > an email from one of my servers:
>
> ....
>

Same problem here, on different machines. But only with mdadm 2.6, with 
mdadm 2.5.5 no problems.

First machine sends direct after starting mdadm in monitor mode:
(kernel 2.6.20-rc3)
-----------------------------
event=DeviceDisappeared
mddev=/dev/md1
device=Wrong-Level

Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
md1 : active raid0 sdb2[1] sda2[0]
      3904704 blocks 16k chunks
      
md2 : active raid0 sdb3[1] sda3[0]
      153930112 blocks 16k chunks
      
md3 : active raid5 sdf1[3] sde1[2] sdd1[1] sdc1[0]
      732587712 blocks level 5, 16k chunk, algorithm 2 [4/4] [UUUU]
      
md0 : active raid1 sdb1[1] sda1[0]
      192640 blocks [2/2] [UU]
      
unused devices: <none>
-----------------------
and a second time for md2.
Then every about 60 sec 4 times

event=SpareActive
mddev=/dev/md3

******************************

Second machine sends about every 60sec 8 messages with:
(kernel 2.6.19.2)
--------------------------
event=SpareActive
mddev=/dev/md0
device=

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md1 : active raid1 sdb1[1] sda1[0]
      979840 blocks [2/2] [UU]
      
md3 : active raid5 sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
      4899200 blocks level 5, 8k chunk, algorithm 2 [6/6] [UUUUUU]
      
md2 : active raid5 sdh2[7] sdg2[6] sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1] 
sda2[0]
      6858880 blocks level 5, 4k chunk, algorithm 2 [8/8] [UUUUUUUU]
      
md0 : active raid5 sdh3[7] sdg3[6] sdf3[5] sde3[4] sdd3[3] sdc3[2] sdb3[1] 
sda3[0]
      235086656 blocks level 5, 16k chunk, algorithm 2 [8/8] [UUUUUUUU]
      
unused devices: <none>

--------------------------

Both machines had nerver seen any spare device, and there are no failing 
devices, everything works as expected.

<earny>
