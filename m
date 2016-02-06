From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm raid5 dropped 2 disks
Date: Sat, 6 Feb 2016 09:45:55 +0000
Message-ID: <56B5C0D3.7000004@youngman.org.uk>
References: <56B479DD.7070600@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B479DD.7070600@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Andr=c3=a9_Teichert?= <andre_teichert@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/02/16 10:30, Andr=C3=A9 Teichert wrote:
> Should I try --create --assmume-clean sda1 sda2 missing?
> I try to stay calm and pray for help.
> thx a lot

=46ind and download lsdrv by Phil Turmel. You'll need Python 2.7 to run=
 it
iirc.

DO NOT EVEN CONSIDER running "mdadm --create" until you've got all the
data you can out of the drive headers (lsdrv is intended to get this da=
ta).

Post the data from lsdrv to the list, and then someone else will chime
in and help you further.

(If you get --create wrong, you've probably just permanently lost the
contents of your array ...)

Cheers,
Wol

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
