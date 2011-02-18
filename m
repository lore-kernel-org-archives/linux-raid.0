From: NeilBrown <neilb@suse.de>
Subject: Re: physical size of the device inconsistent with superblock, after
 RAID problems
Date: Fri, 18 Feb 2011 12:51:25 +1100
Message-ID: <20110218125125.22037092@notabene.brown>
References: <122234.22513.qm@web65103.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <122234.22513.qm@web65103.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Feb 2011 15:53:11 -0800 (PST) Gavin Flower <gavinflower@yaho=
o.com>
wrote:

> Hi Neil,
>=20
> My attempted post to ext3-users@redhat.com, had not been published th=
ere (even though I had emailed it 4 days ago!), as at a minute ago.
>=20
> I finally bit the bullet and went ahead.
>=20
> I accepted the fixes put forward by fsck associated with bitmap diffe=
rences, and rebooted.
>=20
> Still problems.
>=20
> Still had the discrepancy in the file size.=A0 So I ran the command:
>=20
> resize2fs -p /dev/md1 76799616
>=20
> I used the smaller of the 2 block counts, as:
> (a) I needed to reduce the file system size, because I had already re=
duced the RAID size (I _SHOULD_ have done this first, before resizing t=
he RAID), and
> (b) it is reported as the 'physical' size of the device, so it is lik=
ely to be the correct value IMHO
>=20
> The system the came up successfully after a reboot, and I was able to=
 log in as normal.
>=20
> There appeared to be no apparent loss of data, not that I did an exha=
ustive systematic check. However, several users have logged on successf=
ully, and it is playing its part as gateway to the Internet, and squid =
appears to be providing its normal functionality.
>=20
> Neil, your help and encouragement was/is greatly appreciated!
>=20

Excellent!  I'm glad you found a way through.
As you didn't really trim very much from your device it is certainly po=
ssible
that no critical data was there.  Quite possibly resize2fs would have t=
old
you if there was (I certainly hope it would have done).

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
