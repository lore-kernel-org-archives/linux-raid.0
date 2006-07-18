From: Neil Brown <neilb@suse.de>
Subject: Re: Problem with 3xRAID1 to RAID 0
Date: Tue, 18 Jul 2006 11:03:39 +1000
Message-ID: <17596.13163.100902.855435@cse.unsw.edu.au>
References: <44B3562B.7040801@vladoportos.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Vladimir Strycek on Tuesday July 11
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Strycek <vladoportos@vladoportos.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 11, vladoportos@vladoportos.sk wrote:
> Hi,
> 
> I created to 3 x /dev/md1 to /dev/md3  which consist of six identical 
> 200GB hdd
> 
> my mdadm --detail --scan looks like
> 
> Proteus:/home/vladoportos# mdadm --detail --scan
> ARRAY /dev/md1 level=raid1 num-devices=2 UUID=d1fadb29:cc004047:aabf2f31:3f044905
>    devices=/dev/sdb,/dev/sda
> ARRAY /dev/md2 level=raid1 num-devices=2 UUID=38babb4d:92129d4a:94d659f1:3b238c53
>    devices=/dev/sdc,/dev/sdd
> ARRAY /dev/md3 level=raid1 num-devices=2 UUID=a0406e29:c1f586be:6b3381cf:086be0c2
>    devices=/dev/sde,/dev/sdf
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=c04441d4:e15d900e:57903584:9eb5fea6
>    devices=/dev/hdc1,/dev/hdd1
> 
> 
> and mdadm.conf
> 
> DEVICE partitions
> ARRAY /dev/md4 level=raid0 num-devices=3 UUID=1c8291ba:2d83cf54:2698ce30:e49b1e6c
>    devices=/dev/md1,/dev/md2,/dev/md3
> ARRAY /dev/md3 level=raid1 num-devices=2 UUID=a0406e29:c1f586be:6b3381cf:086be0c2
>    devices=/dev/sde,/dev/sdf
> ARRAY /dev/md2 level=raid1 num-devices=2 UUID=38babb4d:92129d4a:94d659f1:3b238c53
>    devices=/dev/sdc,/dev/sdd
> ARRAY /dev/md1 level=raid1 num-devices=2 UUID=d1fadb29:cc004047:aabf2f31:3f044905
>    devices=/dev/sda,/dev/sdb
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=c04441d4:e15d900e:57903584:9eb5fea6
>    devices=/dev/hdc1,/dev/hdd1

Get rid of the "devices=..." lines.  You don't want them - though they
aren't causing a problem yet...

What happens if you
  mdadm --stop --scan
  mdadm --assemble --scan

What gets assembled?

NeilBrown
