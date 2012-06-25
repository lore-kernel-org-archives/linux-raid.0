From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: All spares in Raid 5, default chunk? version of mdadm significant?
Date: Mon, 25 Jun 2012 12:20:06 +0530
Message-ID: <B619C027-FD5C-450E-8CE6-EDEC1D1092D6@gmail.com>
References: <CAK-d5dYwa69wcSGX-u97WmJbMceEX2D1wiXRea-mS+X+i9Dyyw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5dYwa69wcSGX-u97WmJbMceEX2D1wiXRea-mS+X+i9Dyyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
 Hate to bump a thread but have I missed any information that would help to get me help :)? 

Neil, 
 as far as the default chunk sizes and mdadm versions are concerned, I am guessing you may be amongst the few who would know that conclusively? Also could the data offset and super offset be significant?

Thanks,
Anshu

On 22-Jun-2012, at 5:50 PM, Anshuman Aggarwal wrote:

> Hi,
>  I have a 6 device raid 5 array which had 1 disk go bad and then due to a power outage, the machine shutdown and when it started all the disks were showing up as spares with the following mdadm -E output (sample for one given below and full for all devices attached).
> 
> This md device was part a Physical Volume for a LVM Volume Group. 
> 
> I am trying to recreate the array using mdadm --create --assume-clean using 1 device as missing. I am checking if the device is getting created correctly by checking the UUID of the created device which would match if the device gets created correctly.
> 
> I have tried a few combinations of the disk order that I believe is right however I think I'm getting tripped up by the fact that the mdadm I used to create this md device was some 2.x series and now we are on 3.x (and I may have taken some of the defaults originally which I don't' remember)
> What all 'defaults' have changed over the versions so I can try those? Like chunk size? Can we manually configure the super/data offset? Are those significant when we do an mdadm --create --assume-clean?
> 
> Thanks,
> Anshu
> 
> /dev/sda5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : b480fe0c:c9e29256:0fcf1b0c:1f8c762c
>            Name : GATEWAY:RAID5_500G
>   Creation Time : Wed Apr 28 16:10:43 2010
>      Raid Level : -unknown-
>    Raid Devices : 0
> 
>  Avail Dev Size : 976768002 (465.76 GiB 500.11 GB)
>   Used Dev Size : 976765954 (465.76 GiB 500.10 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : a8499a91:628ddde8:1cc8f4b9:749136f9
> 
>     Update Time : Sat May 19 23:04:23 2012
>        Checksum : 9950883c - correct
>          Events : 1
> 
> 
>    Device Role : spare
>    Array State :  ('A' == active, '.' == missing)
> 
> <md5.txt>

