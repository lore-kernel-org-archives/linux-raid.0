From: NeilBrown <neilb@suse.de>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQ=?= RAID5-asking for some
 assistance
Date: Sun, 24 Apr 2011 18:41:30 +1000
Message-ID: <20110424184130.1692bce5@notabene.brown>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>
	<20110423074411.78fef94f@notabene.brown>
	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>
	<20110423184824.55ee7893@notabene.brown>
	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>
	<20110424075101.6763309f@notabene.brown>
	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
	<20110424125401.3de3720d@notabene.brown>
	<BANLkTi=8P75-wUBq149wiM-=XGVa2HBuvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=8P75-wUBq149wiM-=XGVa2HBuvA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Valarti <mdadmuser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 24 Apr 2011 01:06:52 -0600 John Valarti <mdadmuser@gmail.com> w=
rote:

> On Sat, Apr 23, 2011 at 8:54 PM, NeilBrown <neilb@suse.de> wrote:
> ..
> > Could you please run this set of commands exactly as given and send=
 me the
> > complete output. =A0Maybe put them in a file and run
> > =A0sh -x file > /path/on/usb 2>&1
> >
> >
> > cat /proc/mdstat
> > mdadm --stop --verbose /dev/md1
> > ls -l /dev/sd[acd]2
> > mdadm -E /dev/sd[acd]2
> > mdadm -Afvv /dev/md1 /dev/sd[acd]2
> > cat /proc/mdstat
> > dmesg | tail -100
> >
>=20
> Here you go. I warn you it is a bit long!

Thanks.  Length is no problem.

Only it doesn't make sense at all.  I cannot see how mdadm would possib=
ly be
generating just those messages.
It appear to be rejecting each device for some reason, but it not repor=
ting
why it is rejecting the device...

What version of mdadm is this?
   mdadm --version

I should have asked that before.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
