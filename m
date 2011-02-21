From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 15:30:44 -0300
Message-ID: <AANLkTin0hd+=mCP5LXUJHjXtfzZ+mKe0b3GonX6Xir2h@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
	<20110209161916.GB8632@bounceswoosh.org>
	<4D62ADD4.8080601@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D62ADD4.8080601@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: "Eric D. Mudama" <edmudama@bounceswoosh.org>, "Scott E. Armitage" <launchpad@scott.armitage.name>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

just some ideas...

hummm thinking about TRIM in a mixed supported/non supported raid1 arra=
y...

when a filesystem will read a block that is trimmed?
since filesystem first write and after read, maybe never
trimmed blocks are unused blocks (filesystem know where they are)
maybe with a (read/compare/write if diff) resync function, we will
have problems with non trimmed (with support to TRIM) disks being
added on raid1
maybe....

i think that sending trim to devices isn=B4t a problem, it=B4s
optimization of disk that must be done by filesystem, raid1 should
only send this command  to disks. the problem is, if a disk don=B4t hav=
e
trim, we must implement a trim compatible command (or not...
filesystem know about free blocks)



2011/2/21 Phillip Susi <psusi@cfl.rr.com>:
> On 2/9/2011 11:19 AM, Eric D. Mudama wrote:
>> For SATA devices, ATA8-ACS2 addresses this through Deterministic Rea=
d
>> After Trim in the DATA SET MANAGEMENT command. =A0Devices can be
>> indeterminate, determinate with a non-zero pattern (often all-ones) =
or
>> determinate all-zero for sectors read after being trimmed.
>
> IIRC, it was a word in the IDENTIFY response, not the DATA SET
> MANAGEMENT command.
>
> On 2/9/2011 11:28 AM, Scott E. Armitage wrote:
>> Who sends this command? If md can assume that determinate mode is
>> always set, then RAID 1 at least would remain consistent. For RAID 5=
,
>> consistency of the parity information depends on the determinate
>> pattern used and the number of disks. If you used determinate
>> all-zero, then parity information would always be consistent, but th=
is
>> is probably not preferable since every TRIM command would incur an
>> extra write for each bit in each page of the block.
>
> The drive tells YOU how its trim behaves; you don't command it.
>
> If the drive is deterministic and always returns zeros after TRIM, th=
en
> mdadm could pass the TRIM down and process it like a write of all zer=
os,
> and recompute the parity. =A0If it isn't deterministic, then I don't =
think
> there's anything you can do to handle TRIM requests.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
