From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm raid5 dropped 2 disks
Date: Sat, 6 Feb 2016 09:03:27 -0500
Message-ID: <56B5FD2F.9060005@turmel.org>
References: <56B479DD.7070600@gmx.de> <56B5D103.8070908@gmx.de>
 <56B5DD2B.50307@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B5DD2B.50307@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, =?UTF-8?Q?Andr=c3=a9_Teichert?= <andre_teichert@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Andr=C3=A9, Wol,

On 02/06/2016 06:46 AM, Wols Lists wrote:
> On 06/02/16 10:54, Andr=C3=A9 Teichert wrote:
>> glad it worked. Will save lsdrv and hope never to use it. Create new
>> backupplan!
>=20
> Please DO use lsdrv. EVERY time you create or change the config of an
> array, run it and save the info somewhere safe.

Yes, lsdrv is intended to document a running system for later use when
not running.  Especially serial numbers, device names, UUIDs, and layer
relationships.  It is still helpful later, but naturally some info can
be missed.

> Neil has just stepped down as maintainer and Phil is now "one of the
> team",

That's a bit of a stretch.  I'm not maintaining any code and I'm
volunteering on the list as I have in the past.

> he wrote that utility specifically to help in recovering crashed
> arrays. If anything goes wrong and you've got that data to hand, it'l=
l
> make their lives much easier to help you.

Yes, array configuration documentation is critical to recovery.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
