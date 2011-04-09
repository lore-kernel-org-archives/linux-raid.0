From: NeilBrown <neilb@suse.de>
Subject: Re: help please - recovering from failed RAID5 rebuild
Date: Sat, 9 Apr 2011 21:29:30 +1000
Message-ID: <20110409212930.6f4ffb28@notabene.brown>
References: <BANLkTinAmEgsbOx4k5yxCdHmM0GBWbXdBA@mail.gmail.com>
	<20110408220130.4830852d@notabene.brown>
	<BANLkTimSh8f8cVihRxbKgKZq4zFv6VUmVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimSh8f8cVihRxbKgKZq4zFv6VUmVQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: sanktnelson 1 <sanktnelson@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 9 Apr 2011 11:27:20 +0200 sanktnelson 1 <sanktnelson@googlemail=
=2Ecom>
wrote:

> 2011/4/8 NeilBrown <neilb@suse.de>:
> =20
> >
> > Maybe the best thing to do at this point is post the output of
> > =A0mdadm -E /dev/sd[bcdef]1
> > and I'll see if I can make sense of it.
>=20
> Thanks for your advice! here is the output:

It looks like it is in reasonably good shape (relatively speaking...).

I would
  mdadm -S /dev/md0
  mdadm -Af /dev/md0 /dev/sd[bdef]1
  fsck -nf /dev/md0

and if it looks good
  mount /dev/md0
  copy off any data that you can that you cannot live without.

Then stop the array
  mdadm -S /dev/md0
and copy sdd to sdc with dd-rescue
When that completes, assemble the array with
  mdadm -A /dev/md0 /dev/sd[bcef]1
  fsck -nf /dev/md0

and then if it looks good
  mdadm --zero /dev/sdd1
  mdadm /dev/md0 --add /dev/sdd1
and with luck it will successfully rebuild sdd1 and you will have redun=
dancy
again.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
