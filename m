From: Hank Barta <hbarta@gmail.com>
Subject: Re: Help - raid not assembling right on boot (was: Resizing a RAID1)
Date: Thu, 27 Jan 2011 20:50:28 -0600
Message-ID: <AANLkTi=Hh2eownnd2yF6aXgEPFq9ZnU7gufydNGFe25t@mail.gmail.com>
References: <AANLkTimJiZHjAYkd4+93=-5b3QZfSqxaz2Ap+YPLYLEL@mail.gmail.com>
	<alpine.DEB.2.00.1101270656230.31246@p34.internal.lan>
	<AANLkTikP3mVU+=F6Luy5dzj7J9+6cvfZKUaifFW6RUf6@mail.gmail.com>
	<20110128074758.3cb39926@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110128074758.3cb39926@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 27, 2011 at 2:47 PM, NeilBrown <neilb@suse.de> wrote:
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0 =C2=A0=
20973567 =C2=A0 =C2=A010485760 =C2=A0 fd =C2=A0Linux raid autodetect
>> /dev/sdb2 =C2=A0 =C2=A0 =C2=A0 =C2=A020973568 =C2=A03907029167 =C2=A0=
1943027800 =C2=A0 fd =C2=A0Linux raid autodetect
>
> These start numbers are multiples of 64K.
>
> With 0.90 metadata, md thinks that the metadata for a partition that =
starts
> at a multiple of 64K and ends a the end of the device looks just like=
 metadata
> for the whole devices.
>
> If you use 1.0 (or 1;1 or 1.2) metadata this problem will disappear.

Many thanks for the tip.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
              1, 1.0, 1.1, 1.2
                     Use the new version-1 format superblock.   This
has  few  restric=E2=80=90
                     tions.   The different sub-versions store the
superblock at differ=E2=80=90
                     ent locations on the device, either at the end
(for  1.0),  at  the
                     start (for 1.1) or 4K from the start (for 1.2).
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I went with 1.1 and that seems to work w/out this problem.

thanks,
hank

--=20
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
