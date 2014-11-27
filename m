From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: One question about man mdadm
Date: Thu, 27 Nov 2014 08:33:23 +0100
Message-ID: <5476D3C3.3000108@aei.mpg.de>
References: <1267277039.5310948.1417073236902.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1267277039.5310948.1417073236902.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

On 11/27/2014 08:27 AM, Xiao Ni wrote:
>     It says "See md(4) for  more  detail  about =E2=80=99near=E2=80=99=
, =E2=80=99offset=E2=80=99, and =E2=80=99far=E2=80=99"
> What's md(4) mean? Where can I find the detail information about this=
?
>

That's just the short form of, please see man-page about md from sectio=
n=20
4. On the command line

man 4 md

and it should show something like




NAME
        md - Multiple Device driver aka Linux Software RAID

SYNOPSIS
        /dev/mdn
        /dev/md/n
        /dev/md/name

DESCRIPTION
        The  md  driver  provides virtual devices that are created from=
=20
one or more independent underlying devices.  This array of devices ofte=
n=20
contains redundancy and
        the devices are often disk drives, hence the acronym RAID which=
=20
stands for a Redundant Array of Independent Disks.

[...]


Alternatively, first hit with most search engines:

http://linux.die.net/man/4/md

Cheers

Carsten
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
