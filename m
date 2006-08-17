From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid5 grow problem
Date: Thu, 17 Aug 2006 08:48:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0608170847390.9352@p34.internal.lan>
References: <7de068fd0608161815yc34ec6bl886fa637691ee5f8@mail.gmail.com>
 <7de068fd0608170223g2009962chc222233c70ee9317@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-62903789-1155818886=:9352"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7de068fd0608170223g2009962chc222233c70ee9317@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?GB2312?B?yubQxw==?= <xshu2006@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-62903789-1155818886=:9352
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

I've only tried growing a RAID5, which was the only RAID that I remember=20
being supported (to grow) in the kernel, I am not sure if its posible to=20
grow other types of RAID arrays.

On Thu, 17 Aug 2006, =CA=E6=D0=C7 wrote:

> dear sir:
>         i try to make a reshape command with mdadm (version
> 2.5.2).in linux shell ,i make
> $:mdadm -G /dev/md5 /dev/sdd2
> /dev/md5 is a raid5 device with 4 disks,/dev/sdd2 is a partition
> it give the prompt :mdadm :can only add devices to linear arrays,but i
> have read the resourse code of mdadm(V2.5.2),it do really support
> adding several disks into a array (espacially raid5) to make the array
> more large capability.
>
> i want to know  if i want to add(not hotadd) a disk(or a partition) to
> this array ,how can i make an reshape command correctly?
> i have read the help of mdadm ,but i still can't find the correct
> command format!
>   please  do me a favor!
>    thank you !
>                                                                       dra=
gon
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
---1463747160-62903789-1155818886=:9352--
