From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Re: Wierd critical node problem
Date: Tue, 10 Jun 2008 10:30:08 +0200
Message-ID: <200806101030.09019.wayne@flashmedia.co.za>
References: <200806100924.48763.wayne@flashmedia.co.za> <58687.192.168.1.70.1213085722.squirrel@neil.brown.name>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58687.192.168.1.70.1213085722.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Sure thingk.

On Tuesday 10 June 2008 10:15:22 you wrote:
> I suggest you provide lots more details.
> Probably
>   mdadm -Dsv
ARRAY /dev/md5 level=raid1 num-devices=2 
UUID=6868a02e:0e985748:cae821e2:1cf91e6d
   devices=/dev/sdc2,/dev/sdd2
ARRAY /dev/md0 level=raid1 num-devices=4 
UUID=222850cc:3ee166b9:9e71a84f:e86d40a1
   devices=/dev/sdb1,/dev/sda1,/dev/sdd1,/dev/sdc1
ARRAY /dev/md6 level=raid1 num-devices=2 
UUID=bfa44b7a:d6a2d5fc:cae821e2:1cf91e6d
   devices=/dev/sdb2,/dev/sda2
ARRAY /dev/md1 level=raid1 num-devices=4 
UUID=5f6e694f:1d5441a3:7c5e3c07:b6a0267e
   devices=/dev/sdb3,/dev/sdd3,/dev/sdc3,/dev/sda3
ARRAY /dev/md2 level=raid1 num-devices=4 
UUID=020b3642:b32a5fda:ebae4acf:da43fee2
   devices=/dev/sdc5,/dev/sdd5,/dev/sda5,/dev/sdb5
ARRAY /dev/md3 level=raid1 num-devices=4 
UUID=da7d0fc4:ba7f7bd0:bfe35e68:eec9a5cb
   devices=/dev/sda6,/dev/sdc6,/dev/sdd6,/dev/sdb6
ARRAY /dev/md4 level=raid1 num-devices=4 
UUID=5785dcb6:10ba80a4:b169e59f:d80bc484
   devices=/dev/sdc7,/dev/sda7,/dev/sdb7,/dev/sdd7


> and
>   mdadm -Esv
> would be a good start.
ARRAY /dev/md6 level=raid1 num-devices=2 
UUID=bfa44b7a:d6a2d5fc:cae821e2:1cf91e6d
   devices=/dev/sdb2,/dev/sda2
ARRAY /dev/md0 level=raid1 num-devices=4 
UUID=222850cc:3ee166b9:9e71a84f:e86d40a1
   devices=/dev/sdd1,/dev/sdc1,/dev/sdb1,/dev/sda1
ARRAY /dev/md5 level=raid1 num-devices=2 
UUID=6868a02e:0e985748:cae821e2:1cf91e6d
   devices=/dev/sdd2,/dev/sdc2
ARRAY /dev/md1 level=raid1 num-devices=4 
UUID=5f6e694f:1d5441a3:7c5e3c07:b6a0267e
   devices=/dev/sdd3,/dev/sdc3,/dev/sdb3,/dev/sda3
ARRAY /dev/md2 level=raid1 num-devices=4 
UUID=020b3642:b32a5fda:ebae4acf:da43fee2
   devices=/dev/sdd5,/dev/sdc5,/dev/sdb5,/dev/sda5
ARRAY /dev/md3 level=raid1 num-devices=4 
UUID=da7d0fc4:ba7f7bd0:bfe35e68:eec9a5cb
   devices=/dev/sdd6,/dev/sdc6,/dev/sdb6,/dev/sda6
ARRAY /dev/md4 level=raid1 num-devices=4 
UUID=5785dcb6:10ba80a4:b169e59f:d80bc484
   devices=/dev/sdd7,/dev/sdc7,/dev/sdb7,/dev/sda7

I have found the following in my logs,
Jun  9 17:01:50 lloyd kernel: [   52.912904] mdadm[2656]: segfault at 
0000000000000004 rip 000000000041724c rsp 00007ffff99d9b30 error 4

-- 
Regards
Wayne
