From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Mon, 26 Apr 2010 11:18:50 -0700
Message-ID: <t2k4877c76c1004261118m4991141en8b107872b802b237@mail.gmail.com>
References: <535203.18346.qm@web65402.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <535203.18346.qm@web65402.mail.ac4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Klaassen <clawsoon@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 26, 2010 at 9:15 AM, Andrew Klaassen <clawsoon@yahoo.com> w=
rote:
> I've got 4 fibre channel JBODs that I want to use with mdadm RAID 10.=
 =A0They have 14 drives each, for a total of 56 drives.
>
> I'd like to create a RAID-10 device where no copies end up on the sam=
e JBOD. =A0IOW, if copy 1 goes to the first drive on the first JBOD, co=
py 2 should go to the first drive on the third JBOD. =A0If copy 1 goes =
to the second drive on the second JBOD, copy 2 should go to the second =
drive on the fourth JBOD.
>
> How should I order the drives on my mdadm --create command line?
>
> Here's more-or-less what I want in pictures, using 3 drives per JBOD =
for simplicity, with A,B,a,b,1,2 meaning the same thing they do in the =
RAID FAQ:
>
> jbod-1-1 Aa1 Ba1 Ca1
> jbod-1-2 Ab1 Bb1 Cb1
> jbod-1-3 Ac1 Bc1 Cc1
>
> jbod-2-1 Da1 Ea1 Fa1
> jbod-2-2 Db1 Eb1 Fb1
> jbod-2-3 Dc1 Ec1 Fc1
>
> jbod-3-1 Aa2 Ba2 Ca2
> jbod-3-2 Ab2 Bb2 Cb2
> jbod-3-3 Ac2 Bc2 Cc2
>
> jbod-4-1 Da2 Ea2 Fa2
> jbod-4-2 Db2 Eb2 Fb2
> jbod-4-3 Dc2 Ec2 Fc2
>
> The data doesn't have to look exactly like that, as long as the princ=
iple is maintained: The copies of the data should be on disks in separa=
te JBODs.
>
> Thanks.
>
> Andrew
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I don't think I've read the RAID FAQ you speak of, a link would have
been helpful.

However as long as you remember that currently raid10 cannot be grown
(*may have very very recently changed) you can use any of the layouts
you like (I tend to prefer the 'far' layout).

mdadm --create ... --layout=3D(man mdadm) blockdev0 blockdev1 blockdev2=
 blockdev3

n2 =3D=3D Creates almost the behavior you described; each stripe consis=
ts
of b0c0 b0c1 b1c0 b1c1 (blockXcopyY)
o2 =3D=3D Data backup is in the next stripe: that is mirrored and rotat=
ed
stripes: b0c0 b1c0 b2c0 b3c0 // b3c1 b0c1 b1c1 b2c1
f2 =3D=3D The first half is like raid0; the second half is like the o2
above, but over the entire first half.

More info on far from man 4 md
       When 'far' replicas are chosen, the multiple copies of a given
chunk are laid out quite distant from each other.  The  first  copy
of all  data  blocks  will  be striped across the early part of all
drives in RAID0 fashion, and then the next copy of all blocks will be
striped across a later section of all drives, always ensuring that all
copies of any given block are on different drives.

       The 'far' arrangement can give sequential read performance
equal to that of a RAID0 array, but at the cost of  reduced  write
performance.

To elaborate: a 'drive' being a given block device you have specified
via --create or --add.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
