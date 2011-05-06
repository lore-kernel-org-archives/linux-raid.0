From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 06 May 2011 10:22:33 +0100
Message-ID: <4DC3BDD9.1060300@abpni.co.uk>
References: <20110506071752.GA22063@www2.open-std.org> <20110506133159.30c66519@natsu> <20110506090345.GA22245@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506090345.GA22245@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 06/05/2011 10:03, Keld J=F8rn Simonsen wrote:
> On Fri, May 06, 2011 at 01:31:59PM +0600, Roman Mamedov wrote:
>   =20
>> On Fri, 6 May 2011 09:17:52 +0200
>> Keld J=F8rn Simonsen<keld@keldix.com>  wrote:
>>
>>     =20
>>> I would like linux MD raid10 functionality to be part of the Linux =
MD
>>> RAID1 module, and be called raid1. This is in accordance with the
>>> use of the RAID1 term as standadized by SNIA. In fact the RAID10-of=
fset
>>> layout is an implementation of a SNIA RAID specification. The RAID1=
0-near
>>> layout is an implementation of a simple RAID layout. And the RAID10=
-far
>>> layout is just another layout far a mirrored RAID.  So all these ty=
pes
>>> could just be defined as different RAID1 layouts.
>>>       =20
>> RAID1 is RAID1, RAID10 is RAID10.
>> RAID1 on 4 drives is very different from RAID10 on 4 drives.
>> Don't add confusion by trying to rename RAID10 to RAID1.
>>     =20
> How are they different?
> Say what is the difference between a Linux MD RAID1 with 4 disks, and
> the default Linux MD RAID10 with 4 disks? (in the near layout)?
>
>   =20
RAID1 is traditionally a mirror only setup (ok, some RAID=20
implementations may do some load-balancing of some sort). So a RAID1=20
with 4 disks is one data set copied onto 4 disks. Bandwidth is roughly=20
the same as a single disk (ignoring any load balancing).
RAID10 is mirror and stripe. A RAID10 with 4 disks is similar to a 2=20
disk RAID0 (double bandwidth with data split in half across both disks)=
,=20
but with each disk having a mirror (which brings the total up to 4 driv=
es).

Additionally, a RAID1 disk (at least using MD) can be accessed just lik=
e=20
a normal disk (good for recovery etc.) however a single disk out of a=20
RAID10 array is next to useless.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
