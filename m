From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Is this likely to cause me problems?
Date: Tue, 21 Sep 2010 23:42:24 -0700 (PDT)
Message-ID: <672252.64237.qm@web51306.mail.re2.yahoo.com>
References: <4C992065.9000107@anonymous.org.uk>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C992065.9000107@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 21/9/10, John Robinson <john.robinson@anonymous.org.uk> wro=
te:

> From: John Robinson <john.robinson@anonymous.org.uk>
> Subject: Re: Is this likely to cause me problems?
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Tuesday, 21 September, 2010, 22:15
> On 21/09/2010 21:33, Jon Hardcastle
> wrote:
> > I am finally replacing an old and now failed drive
> with a new one.
> >=20
> > I normally create a partition the size of the entire
> disk and add that but whilst checking the sizes marry up i
> noticed that is an odity...
> >=20
> > Below is an fdisk dump of all the drives in my RAID6
> array
> >=20
> > sdc---
> > /dev/sdc1=A0 =A0 =A0 =A0 =A0 =A0
> 2048=A0
> 1953525167=A0=A0=A0976761560=A0=A0=A0fd=A0
> Linux raid autodetect
> > ---
> > Seems to be different to sda say which is also '1TB'
> >=20
> > sda---
> > /dev/sda1=A0 =A0 =A0 =A0 =A0 =A0
> =A0 63=A0
> 1953520064=A0=A0=A0976760001=A0=A0=A0fd=A0
> Linux raid autodetect
> > ---
> >=20
> > Now i read somewhere that the sizes flucuate but as
> some core value remains the same can anyone confirm if this
> is the case?
> >=20
> > I am reluctant to add to my array until i know for
> sure...
>=20
> Looks like you've used a different partition tool on the
> new disc than you used on the old ones - old ones started
> the first partition at the beginning of cylinder 1, new ones
> like to start partitions at 1MB so they're aligned on 4K
> sector boundaries and SSDs' erase group boundaries etc. You
> could duplicate the original partition table like this:
>=20
> sfdisk -d /dev/older-disc | sfdisk /dev/new-disc
>=20
> But it wouldn't cause you any problems, because the new
> partition is bigger than the old one, despite starting a
> couple of thousand sectors later. This in itself is odd -
> how did you come to not use the last chunk of your original
> discs?
>=20
> Cheers,
>=20
> John.
>=20

Ok, Thank you.

So do you have any recommendations? I would like to 'trust' the new ver=
sion of fdisk but I can not risk torpedoing myself. I have 2 more drive=
s I need to 'phase out' at some point; but they will liklely be with 1.=
5TB drives.

My gut tells me that i should whilst I have other drives the same size =
use the same paratermeters... then when i have a bigger drive that is d=
efinately not going to cause any size issues let fdisk do its magic.

So following that premsis is there any down side to copy the partition =
table off another drive?


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
