From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 01:03:22 +0100
Message-ID: <201103190103.22656.xavier@alternatif.org>
References: <201103190006.56887.xavier@alternatif.org> <AANLkTimN7TkgpMjfoF5NnUMAjA0jTAfO1Gqnduu9yMwO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimN7TkgpMjfoF5NnUMAjA0jTAfO1Gqnduu9yMwO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le samedi 19 mars 2011 00:57:15, Roberto Spadim =E9crivait :
> did you try to change udev configuration?

no

But attempting to boot on a 2.6.32-27 or 2.6.32-24 kernel result in a f=
reeze=20
short after:
ata_id[919] : HDIO_GET_IDENTITY failed for '/dev/sdb'
And while rebooting with alt + Sysrq + REISUB keys, I saw that udev was=
 stuck=20
on waiting a logitech usb mouse.=20

Xavier
xavier@alternatif.org
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
