From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: mdadm spare-group not working for me
Date: Wed, 7 Jul 2004 11:29:52 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407071114270.20019@praktifix.dwd.de>
References: <Pine.LNX.4.58.0407070745260.20019@praktifix.dwd.de>
 <16619.54193.685669.468567@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16619.54193.685669.468567@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 7 Jul 2004, Neil Brown wrote:

> On Wednesday July 7, Holger.Kiehl@dwd.de wrote:
> > Hello
> > 
> > I am using mdadm 1.5.0 (kernel is 2.6.7) and noticed that spare-groups do
> > not work for me in a raid 10 setup. Here my mdadm.conf:
> > 
> > DEVICE /dev/hda[23567] /dev/hde[23567]
> > DEVICE /dev/sd[abcdef]1
> > DEVICE /dev/md[23456]
> > ARRAY /dev/md0 level=raid1 num-devices=2 UUID=ae4df447:33c21025:00e04356:461073a0
> > ARRAY /dev/md1 level=raid1 num-devices=2 UUID=3d426966:8a378a74:d73267fb:9ec0589c
> > ARRAY /dev/md2 level=raid1 num-devices=2 UUID=4e592020:0cc3ca3a:b983668f:d1595d33
> > ARRAY /dev/md3 level=raid1 num-devices=6 UUID=91e415e1:ab17103b:48d20b4a:1201303c spare-group=afdz
> > ARRAY /dev/md4 level=raid1 num-devices=2 UUID=71a92656:a1ac42c3:34577f43:f85a26ff spare-group=afdz
> > ARRAY /dev/md5 level=raid1 num-devices=2 UUID=7e51c839:aa48864b:b50bd5a5:267a1f1c spare-group=afdz
> > ARRAY /dev/md6 level=raid0 num-devices=3 UUID=c404c58a:42aeef9c:36a67c8e:cd229e88
> > MAILADDR root
> > 
> > Additionally mdadm is started in monitor mode with the following command:
> > 
> > mdadm --monitor /dev/md0 /dev/md1 /dev/md2 /dev/md3 /dev/md4 /dev/md5
> 
> Run mdadm as
>    mdadm --monitor --scan
> instead.  Currently information in the config file is ignored if you
> actually list arrays to monitor.  I acknowledge that that doesn't
> really make sense and will look into changing it, but that is the
> way it is at the moment.
> 
I tried this first but had a configuration error in mdadm.conf that
for /dev/md3 num-devices was set to 2. But setting this to 6 and --scan
this works. Thanks for the quick help!

Is it possible to influence the order at which the spares are taken
from the group? Reason is that I have four spare partitions on two
ide disks (2 partitions on each disk). Removing a second disk I
noticed it picked the second partition from the same disk. The spares
where added in this order hde7 hda7 hde6 hda6, but mdadm picked hde7
and then hde6. Better would be hde then hda.

Thanks,
Holger
