From: Billy Crook <billycrook@gmail.com>
Subject: Re: Help understanding the root cause of a member dropping out of a
	RAID 1 set.
Date: Thu, 13 Aug 2009 11:13:48 -0500
Message-ID: <a43edf1b0908130913x238b33ecref5a3d070bf3cb16@mail.gmail.com>
References: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 13, 2009 at 03:44, Simon Jackson<sjackson@bluearc.com> wrot=
e:
>
> I am running RAID1 partitions on some systems and a few times I have =
seen a raid set become degraded as a member has failed out of the md de=
vice. =A0Looking at the /var/log/message file I have seen output simila=
r to below:
>
> Can anyone help me decode what actually happened here.
>
> Thanks Simon.
>
> 2009-08-11T06:21:04-07:00 Metro-1 kernel: [556568.670377] =A0 =A0 =A0=
 =A0 =A0res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

the hard drive didn't respond to an ata command

> 2009-08-11T06:21:04-07:00 Metro-1 kernel: [556568.670477] ata1: hard =
resetting link

kernel tells hdd controller to reset link. (Sometimes this gets
"frozen" hard drives to respond again.)

> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.122562] ata1: SATA =
link up 3.0 Gbps (SStatus 123 SControl 300)
> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.259057] ata1.00: co=
nfigured for UDMA/133
> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] ata1.01: co=
nfigured for UDMA/133

link has been reset.

> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] md: super_w=
ritten gets error=3D-5, uptodate=3D0

mdraid notices.  says oh craps.

> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] raid1: Oper=
ation continuing on 1 devices.

mdraid marks the component that encountered the error failed, and
keeps on keeping on

> 2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] ata1: EH co=
mplete

ata reset (of link, and subsequently drive) is complete.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
