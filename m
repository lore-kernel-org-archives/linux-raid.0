From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 23 Jul 2008 14:29:37 +0400
Message-ID: <48870811.8050402@wasp.net.au>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <487CEF1A.6050402@wasp.net.au> <20080715201221.GB26439@rap.rap.dk> <4884BF7B.6030206@tmr.com> <20080723074539.GA13549@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080723074539.GA13549@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Bill Davidsen <davidsen@tmr.com>, Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:

>>> It is possible that I am thinking of what you call fakeraid.
>>> =20
>> I like "firmware raid" better, but the bottom line here is that the =
raid=20
>> is still done in the system CPU. These often have little or no hardw=
are=20
>> support, such as cache so that multiple drives can be written withou=
t=20
>> passing the data through the system bus more than once (and chancing=
=20
>> change while that happens).
>=20
> OK, if the definition on these controllers is that they must have sup=
port
> from the OS, then I think most of the mobos today come with hardware
> raid, that is there needs to be no support in Linux for this. Everyth=
ing
> is set up via the bios, and from the linux kernel it looks like an
> ordinary disk.

The problem here is it looks like an ordinary disk to the BIOS only. Gr=
ub can use this to load the=20
kernel and initrd from, but when the kernel boots it sees the controlle=
r as the simple controller it=20
is with some disks connected to it. It requires something like dmraid t=
o make the "array" visible as=20
an actual array.

None of these controllers perform any of the RAID offload themselves, i=
t's all handled by the=20
driver. Windows loads using the BIOS and then hands over to the driver =
which handles the raid, just=20
the same as linux does with dmraid.

I believe some of the ITE chipsets can handle raid-1 and possibly raid-=
0 internally, and the kernel=20
has the ability to drive those as a raid controller, but they are somew=
hat rarer than the other=20
fakeraid implementations out there.

Brad
--=20
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
