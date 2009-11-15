From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: IDE/RAID/AHCI setting in BIOS influcencing mdraid?
Date: Sun, 15 Nov 2009 22:28:43 +0100
Message-ID: <4B00728B.40109@ribosome.natur.cuni.cz>
References: <4AF9F415.9050809@ribosome.natur.cuni.cz> <20091112075203.GA22315@maude.comedia.it> <4AFC3299.3040702@ribosome.natur.cuni.cz> <4AFEE3EA.9080503@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFEE3EA.9080503@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Bill,

Bill Davidsen wrote:
> Martin MOKREJ=C5=A0 wrote:
>> Hi everybody,
>>
>> That is what happened to me. Two disks are not in an ICH9R array but=
 are
>> in raid0 under mdadm. Four disk are under raid10 under ICH9R while a=
lso
>> under raid10 under mdadm.
>>  =20
>=20
> Could you clarify that last sentence? It sounds as if you have two
> independent arrays, using a controller for one and mdraid for the oth=
er,
> and they both use the same drives. Please tell me I'm misreading this=
=2E..

No, you read it correctly. ICH9R controller has 6 disks connected. Firs=
t two
do not have configured array "in BIOS" while latter 4 do have (RAID10).=
 That
was my surprise as the machine uses md-array (the first two disks /dev/=
sd[a-b]1
in raid1, 0.9 superblock) while the latter four /dev/sd[c-f]1 as raid10=
 (0.9
superblock as well). In other words, the four disks in raid10 are assig=
ned twice,
onder to ICH9R while also to md-raid10.

I think that once I configured the BIOS stuff but used subsequently mda=
dm to
create the array under linux. Thus I believe I overwrote the "imsm" sup=
erblock
without even knowing (but then ICH9R BIOS would not report the RAID10 s=
panning
the four disks nowadays, right?).

Thanks,
Martin

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
