From: Neil Brown <neilb@suse.de>
Subject: Re: Softraid wont be restarting
Date: Mon, 17 Apr 2006 08:59:46 +1000
Message-ID: <17474.52322.160740.814031@cse.unsw.edu.au>
References: <443E56FF.4040805@hausstein.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin  =?ISO-8859-1?Q?=20M=FCller?= - Rudolf Hausstein OHG on Thursday April 13
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Martin_M=FCller_-_Rudolf_Hausstein_OHG?= <m.mueller@hausstein.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 13, m.mueller@hausstein.at wrote:
> Hi!
> 
> Since two weeks im trying to remount a Sofraid (Level1) which I created 
> with
> 
> mdadm -Cv /dev/md3 -l1 -2 /dev/sdc1 /dev/sdd1
> 
....
> ----------
> 
> 
> I?m having other softraids, wich are created by the installationsroutine 
> of sarge. These raids are working properly.
> My /etc/mdadm/mdadm.cong looks like this:
> 
> DEVICE partitions
> ARRAY /dev/md2 level=raid1 num-devices=1 spares=1 
> UUID=fd3f5565:700efa41:9c649802:f9165970
> devices=/dev/sda4,/dev/sdb4
> ARRAY /dev/md1 level=raid1 num-devices=1 spares=1 
> UUID=ce956e77:bb6dfc5c:052c5d48:90ccc5a5
> devices=/dev/sda3,/dev/sdb3
> ARRAY /dev/md0 level=raid1 num-devices=1 spares=1 
> UUID=5f5bc322:fe00157d:7f574758:88afc009
> devices=/dev/sda2,/dev/sdb2
> 
> ARRAY /dev/md3 level=raid1 num-devices=1 spares=1
> devices=/dev/sdc1,/dev/sdd1
> 

I suggest getting rid of the "devices=" bits.  You don't want or need
them.


> 
> A part of the bootlog in /var/log/messages :
> 
> Apr 12 15:36:39 localhost kernel: ReiserFS: md3: warning: sh-2006: 
> read_super_block: bread failed (dev md3, block 2, size 4096)

'bread failed' suggests that the array isn't assembled.
If you assemble the array after boot
  mdadm -As /dev/md3
can you then mount the filesystem:
  mount /dev/md3 /wherever
?

I suspect something is wrong with the initramfs that debian created
for you - there have been a lot of complaints about that lately.


NeilBrown
