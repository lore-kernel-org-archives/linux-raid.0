From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Checksumming RAID? / SCSI SAS T10 PI and DIF/DIX / T13 SATA EPP
Date: Thu, 06 Dec 2012 11:10:08 +0000
Message-ID: <50C07D10.3000207@anonymous.org.uk>
References: <14319197.21.1353936449959.JavaMail.root@zimbra> <20121203122444.GV8912@reaktio.net> <20121203140946.GW8912@reaktio.net> <yq1vccgjp4o.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1vccgjp4o.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/12/2012 19:05, Martin K. Petersen wrote:
>>>>>> "Pasi" =3D=3D Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> writes:
> Pasi> (Added CC to Martin in the case he has some thoughts about gene=
ric
> Pasi> Linux checksumming RAID without T10 PI disks..)
>
> There have been a few attempts at a checksumming DM target. However, =
I
> think btrfs is a much better solution for this stuff.

I think there's room for both. Checksumming at the block level, below m=
d=20
RAID so presumably in a DM target, could help avoid silent data=20
corruption in such a way that the md layer could reconstruct valid data=
=2E=20
Checksumming at the filesystem level doesn't give you reconstruction -=20
unless you add redundancy/RAID functions into the filesystem, which is =
a=20
whole other discussion.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
