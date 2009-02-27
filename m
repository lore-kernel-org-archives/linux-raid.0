From: PGNet <pgnet.trash+raid@gmail.com>
Subject: Re: can metadata type be changed for an active array?
Date: Thu, 26 Feb 2009 21:10:07 -0800
Message-ID: <dbd51810902262110t5c5a996ew42662c9b399812ab@mail.gmail.com>
References: <dbd51810902261112h26ca8429l835272401f555c54@mail.gmail.com>
	 <983bc6fdcd28a2885e2c5933dafc72eb.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <983bc6fdcd28a2885e2c5933dafc72eb.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

On Thu, Feb 26, 2009 at 8:57 PM, NeilBrown <neilb@suse.de> wrote:
> However the 1.0 metadata uses less space than the 0.90 metadata so
> it is fairly safe to simply stop the array and then create it with 1.=
0
> metadata. =A0All your data will still be there.

curious, is that also true for 1.0 -> 1.2 ?

> The bitmap could get written at a different place, and could over-wri=
te
> data. =A0So to be safe:

got it.

>  mdadm --assemble /dev/md5 --metadata=3D1.0 --update=3Dmetadata  /dev=
/sd[ab]2

fair enough.

thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
