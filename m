From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Is mdadm --create safe for existing arrays ?
Date: Wed, 16 Aug 2006 09:15:41 -0700
Message-ID: <44E344AD.2050001@h3c.com>
References: <20060816152645.9761.qmail@web34611.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060816152645.9761.qmail@web34611.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Warning: I'm not certain this info is correct (I test on fake loopback
arrays before taking my own advice - be warned). More authoritative
folks are more than welcome to correct me or disagree.

create is safe on existing arrays in general, so long as you get the ol=
d
device order correct in the new create statement, and you use the
'missing' keyword appropriately so resyncs don't start immediately and
you can mount the device to make sure you're data is there. Once you're
certain, you add a drive in place of the missing component, sync up, an=
d
you're set.

In this case, that'd be an 'mdadm --create -l1 -n2 /dev/md0 /dev/sda1
missing'. You should have an array there that you can test.

But wait!

If the superblock wasn't persistent before, it's possible that the
device is using the space that would be used for the superblock for
filesystem information - it may not be reserved for md use. This is
where I'm not sure.

If that's the case, re-creating with persistent superblocks may clobber
the end of your filesystem, and you may not notice until you try to use=
 it.

There was a thread quite recently (one week? two? can't quite remember)
specifically about putting a non-raid FS into a raid set that touched o=
n
these issues, and how to do the FS shrink so it would have room for the
raid superblock. I'd refer to that. The goal being to shrink 1MB or so
off the FS, create the raid, then grow the FS to max again (or let it
be, whatever)

-Mike

Peter Greis wrote:
> Greetings,
>=20
> I have a SuSE 10.0 raid-1 root which will not properly
> boot, and I have noticed that / and /boot have
> non-persistent super blocks (which I read is required
> for booting).
>=20
> So, how do I change / and /boot to make the super
> blocks persistent ? Is it safe to run "mdadm --create
> /dev/md0 --raid-devices=3D2 --level=3D1 /dev/sda1
> /dev/sdb1" without loosing any data ?
>=20
> regards,
>=20
> Peter
>=20
> PS Yes, I have googled extensively without finding a
> conclusive answer.
> =20
>=20
> Peter Greis
> freethinker gmbh
> St=E4fa Switzerland
>=20
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam protection around=20
> http://mail.yahoo.com=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
