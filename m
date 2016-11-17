From: Wols Lists <antlists@youngman.org.uk>
Subject: Re:
Date: Thu, 17 Nov 2016 22:12:18 +0000
Message-ID: <582E2B42.9070804@youngman.org.uk>
References: <CAGELip+rb=Ztv2K8jPdn608Li_RakEq9Gp5Jyof9eC_bO5QMrQ@mail.gmail.com>
 <CAGELipKk-J3yD7aoc0=w-JgMHaW6OGWhtmhjehGVV4kQ0a3g_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGELipKk-J3yD7aoc0=w-JgMHaW6OGWhtmhjehGVV4kQ0a3g_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Dataopslag <dennisdataopslag@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/11/16 20:33, Dennis Dataopslag wrote:
> CHeers for the reaction and sorry for my late response, I've been out
> for business.
> 
> Trying to rebuild this RAID is definately worth it for me. The
> learning experience alone already makes it worth.
> 
> I did read the wiki page and tried several steps that are on there but
> it didn't seem to get me out of trouble.
> 
> I used this information from the drive, obviously didn't search for
> any "hidden" settings:
> " Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 36fdeb4b:c5360009:0958ad1e:17da451b
>            Name : TRD106:0  (local to host TRD106)
>   Creation Time : Fri Oct 10 12:27:27 2014
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 1948250112 (929.00 GiB 997.50 GB)
>      Array Size : 5844750336 (2786.99 GiB 2992.51 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : b49e2752:d37dac6c:8764c52a:372277bd
> 
>     Update Time : Sat Nov  5 14:40:33 2016
>        Checksum : d47a9ad4 - correct
>          Events : 14934
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Device Role : Active device 0
>    Array State : AAAA ('A' == active, '.' == missing)"
> 
> Anybody that can give me a little extra push?
> 
Others will be able to help better than me, but you might want to look
for the thread "RAID10 with 2 drives auto-assembled as RAID1".

This will give you some information about how to run hexdump and find
where your filesystems are on the array.

There's plenty of other threads with this sort of information, but this
will give you a starting point. If Phil Turmel sees this, he'll chime in
with better detail.

Cheers,
Wol

