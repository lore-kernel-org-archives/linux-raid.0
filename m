From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID5 - RAID6
Date: Sun, 7 Mar 2010 20:19:51 -0800
Message-ID: <4877c76c1003072019k1a91e851k29f0f9e9c4b776cc@mail.gmail.com>
References: <0A.0B.21054.6EC649B4@cdptpa-omtalb.mail.rr.com>
	 <0C.BD.21054.79E649B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C.BD.21054.79E649B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 7, 2010 at 7:27 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
>
>> > >> You need mdadm-3.1.1 plus linux 2.6.32.
>> > >>
>> > >> NeilBrown
>> > >>
>> > >> >
>> > >> > --
>> > >> > To unsubscribe from this list: send the line "unsubscribe lin=
ux-
>> raid"
>> > in
>> > >> > the body of a message to majordomo@vger.kernel.org
>> > >> > More majordomo info at =A0http://vger.kernel.org/majordomo-in=
fo.html
>> > >
>> > >
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-=
raid"
>> in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
>> > >
>> >
>> > What are you talking about?
>>
>> =A0 =A0 =A0 Referring to what, specifically?
>>
>> > Have you not synced to the online
>> > repository? =A0I grabbed this out of the Package.bz2 file.
>>
>> =A0 =A0 =A0 Of course. =A0I'm running "Lenny" for an AMD-64. =A0The =
output below is
>> definitely not for AMD-64, and it looks to me like it might be "Sque=
eze"
>> or
>> "Sid", not "Lenny".
>>
>> >From the "Lenny" AMD-64 Package.bz2 file:
>
> =A0 =A0 =A0 =A0Digging a bit further, even "Squeeze" does not offer m=
dadm 3.1.1, at
> least not in the AMD-64 distro. =A0It's included version at the momen=
t is
> 3.0.3-2.
>
>

Yes, but it's kernel is supported.  You need only run the newer
version during the reshape phase.  Otherwise normal operations should
still be supported.  The requirements to compile mdadm aren't exactly
a full development system.  You don't even have to install it to run
it; you can do that in the build area.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
