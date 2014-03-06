From: Jared Raddigan <jraddigan@kfh.org>
Subject: Re: Grow on RAID 6 failed can I revert back to previous total drives?
Date: Thu, 6 Mar 2014 11:28:04 -0800
Message-ID: <CAK=+6WJ4umzHuWsy1BGSzy_3uAAyGSdn9EpbGHvUU2rnYZ_NtA@mail.gmail.com>
References: <CAK=+6WKH2ffSEVD2=gMoqS2RbVNBEFyVCtDrQtM+eDaNNrb1ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK=+6WKH2ffSEVD2=gMoqS2RbVNBEFyVCtDrQtM+eDaNNrb1ig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can ignore this request. I tried to recreate the array and I was
unable to recover. I moved to plan B so this is no longer needed.

Thanks,

Jared

On Wed, Mar 5, 2014 at 4:16 PM, Jared Raddigan <jraddigan@kfh.org> wrote:
> Using:
> Debian 7
> mdadm - v3.2.5 - 18th May 2012
>
> I had a working 5 disk (3TB each) Raid 6 array. I was running out of
> room so I wanted to expand it. I added a SATA controller card and 3
> more 3TB drives following the
> https://raid.wiki.kernel.org/index.php/Growing guide.
>
> The three additional drives failed shortly after the grow command and
> further testing shows that the SATA card that I added is flakey at
> best. It went to reshaping mode and the time to complete was about 25
> years :). Not able to get anywhere, I decided to reboot assuming I am
> probably going to lose my data. I have already have moved to plan B
> but recovering some data would be nice if possible.
>
> So I now have a RAID 6 array that wont start because it does not have
> enough drives. I cant really try to re-add those drives because the I
> don't trust the SATA card. It really only ran for probably 10 minutes
> before it failed. Here is what I wanted to ask before I tried it.  I
> basically want to rebuild my array with the original 5 drives and see
> if I can recover any data.
>
> I was going through the recovery guide and am now at the bottom
> section "restore array by recreating."  Would it be foolish to try and
> recreate the array with only 5 original drives, something like this.
>
>  mdadm --create --assume-clean --level=6 --raid-devices=5
> --size=2930133504 /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> /dev/sdf1
>
> I had to change the size as when I used the value in the guide  "Used
> Dev Size/2" mdadm reported
>
> mdadm: /dev/sdf1 is smaller than given size. 2930133504K < 2930263552K
> + metadata
>
> for each drive. If I use the 2930133504 it appears now that I can hit
> Yes an proceed. The guide said before getting hasty post here so any
> feedback would be appreciated.
>
> Thanks,
>
>
> Jared
>
>
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : aad17236:47b3d29e:124f709c:5e61a7be
>            Name : backy3:0  (local to host backy3)
>   Creation Time : Tue Oct 11 14:27:53 2011
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>      Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
>   Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 0b6dd63f:091a9e59:30443384:41314df2
>
>   Reshape pos'n : 199680 (195.03 MiB 204.47 MB)
>   Delta Devices : 3 (5->8)
>
>     Update Time : Wed Mar  5 10:46:19 2014
>        Checksum : e0b50220 - correct
>          Events : 98709
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAAAA... ('A' == active, '.' == missing)
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : aad17236:47b3d29e:124f709c:5e61a7be
>            Name : backy3:0  (local to host backy3)
>   Creation Time : Tue Oct 11 14:27:53 2011
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>      Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
>   Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : a3a2d182:8492d2a3:ad7e389e:54cd2955
>
>   Reshape pos'n : 199680 (195.03 MiB 204.47 MB)
>   Delta Devices : 3 (5->8)
>
>     Update Time : Wed Mar  5 10:46:19 2014
>        Checksum : eac6871c - correct
>          Events : 98709
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AAAAA... ('A' == active, '.' == missing)
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : aad17236:47b3d29e:124f709c:5e61a7be
>            Name : backy3:0  (local to host backy3)
>   Creation Time : Tue Oct 11 14:27:53 2011
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>      Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
>   Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : ab14917c:3077a9fe:a14ec7d1:5de769d1
>
>   Reshape pos'n : 199680 (195.03 MiB 204.47 MB)
>   Delta Devices : 3 (5->8)
>
>     Update Time : Wed Mar  5 10:46:19 2014
>        Checksum : ef2bc777 - correct
>          Events : 98709
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 2
>    Array State : AAAAA... ('A' == active, '.' == missing)
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : aad17236:47b3d29e:124f709c:5e61a7be
>            Name : backy3:0  (local to host backy3)
>   Creation Time : Tue Oct 11 14:27:53 2011
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>      Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
>   Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 3d574712:561cbf1f:1efc6ca8:c987b6f8
>
>   Reshape pos'n : 199680 (195.03 MiB 204.47 MB)
>   Delta Devices : 3 (5->8)
>
>     Update Time : Wed Mar  5 10:46:19 2014
>        Checksum : a3e9fd18 - correct
>          Events : 98709
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : AAAAA... ('A' == active, '.' == missing)
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : aad17236:47b3d29e:124f709c:5e61a7be
>            Name : backy3:0  (local to host backy3)
>   Creation Time : Tue Oct 11 14:27:53 2011
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>      Array Size : 17581581312 (16767.10 GiB 18003.54 GB)
>   Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 9d0d3e75:76c85286:c3597412:13530f39
>
>   Reshape pos'n : 199680 (195.03 MiB 204.47 MB)
>   Delta Devices : 3 (5->8)
>
>     Update Time : Wed Mar  5 10:46:19 2014
>        Checksum : 17d48888 - correct
>          Events : 98709
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 4
>    Array State : AAAAA... ('A' == active, '.' == missing)
