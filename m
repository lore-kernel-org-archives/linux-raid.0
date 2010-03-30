From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 11:00:21 -0700
Message-ID: <5bdc1c8b1003301100o39138befwb99ff4bdbb4dfe2c@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
	 <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 10:47 AM, Jim Duchek <jim.duchek@gmail.com> wro=
te:
> Well it appears that I can absolutely reproduce it 100% of the time b=
y
> copying a large (>1 gig) video file and then immediately playing it.
> It seems to hit the freeze on just about the same frame every time,
> and playing it seems to be necessary (it doesn't freeze if I just do
> the copy and go about my business). =C2=A0Possibly an issue w/disk bu=
ffers?
> =C2=A0You're having this happen even if the disk in question is not i=
n an
> array? =C2=A0If so perhaps it's an SATA issue and not a RAID one, and=
 we
> should move this discussion accordingly. =C2=A0I reproduced your step=
s and
> I'm seeing pretty much the same thing, although not quite hitting 100=
%
> wa (although I'm guessing it would if I shut everything else down --
> Got a full desktop running).
>
> I'm using a Biostar T41-A7 mobo, Intel Core 2 Quad Q8400 Yorkfield
> 2.66GHz 4MB L2, and 3 Western Digital Caviar Blue WD5000AAJS drives
> and 1 WD5002ABYS. =C2=A0I note that the 3 older drives claim using AT=
A-7
> and the newer one says ATA-8. Any similarities?
>
> Jim
>

Intex DX58SO motherboard
6GB
i7 920
3 WD10EARS green 1TB (4K/sector)
nvidia 9500GT
2.6.32-gentoo kernel

In my setup (and being Gentoo based where we build everything from
scratch) I see this mostly when building code. I haven't copied any
large files yet but I'm not surprised at your report as my dmesg error
is about writes being blocked so that makes sense.

Closest similarity would be both motherboards are based on Intel
chipsets. SATA support is in the South Bridge.

Your motherboard chipset

North Bridge 	Intel G41
South Bridge 	Intel ICH7

My motherboard chipset

North Bridge  	Intel X58
South Bridge 	Intel ICH10R

You did see the same message about writes being block, correct?
Nothing else as of yet?


- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
