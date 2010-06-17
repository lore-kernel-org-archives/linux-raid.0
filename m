From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Problem re-shaping RAID6
Date: Thu, 17 Jun 2010 01:20:50 -0700
Message-ID: <AANLkTinX2XFJvZ3Uml3jCypcv674-5tfUeXdBT8vmrQy@mail.gmail.com>
References: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
	<20100614091518.2492a9db@notabene.brown> <20100614124723.84152dz5al8096f4@cakebox.homeunix.net>
	<20100617154708.227cd303@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617154708.227cd303@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Nagilum <nagilum@nagilum.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 16, 2010 at 10:47 PM, Neil Brown <neilb@suse.de> wrote:
> On Mon, 14 Jun 2010 12:47:23 +0200
> Nagilum <nagilum@nagilum.org> wrote:
>
>>
>> ----- Message from neilb@suse.de ---------
>> =A0 =A0 =A0Date: Mon, 14 Jun 2010 09:15:18 +1000
>> =A0 =A0 =A0From: Neil Brown <neilb@suse.de>
>> =A0 Subject: Re: Problem re-shaping RAID6
>> =A0 =A0 =A0 =A0To: J=E9r=F4me Poulin <jeromepoulin@gmail.com>
>> =A0 =A0 =A0 =A0Cc: linux-raid <linux-raid@vger.kernel.org>
>>
>>
>> > Thanks.
>> > I fixed this bug a slightly different way
>> >
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocks =3D ochunk/512 * nchunk/512 *=
 odata * ndata / a;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocks =3D (ochunk/512) * (nchunk/51=
2) * odata * ndata / a;
>> >
>> >
>> > See
>> > http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D200871adf9=
e15d5ad985f28c349fd89c386ef48a
>>
>> Those static numbers always make my nose wrinkle.
>> Don't we have the blocksize somewhere already? I'm also concerned wh=
at
>> happens when true 4k sectors are used..
>>
>
> A sector will always be 512 bytes to Linux, even when we have drives =
that can
> only do IO in multiples of 8 sectors. =A0Changing that would cause wa=
y to many
> headaches.
>
> Yes, =A0I could possibly use a define for '512'. =A0Some times that i=
s
> appropriate, but I thing 512 is so clearly "bytes_per_sector" it woul=
d just
> add an unnecessary level of indirection.
> It is a question of taste really - no right answers.
>
> Thanks,
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Slightly off topic, but wouldn't an 'always' like that be a valid
reason for starting a 2.7 or 3.0 branch; that is something where major
sections of code would /have/ to be changed even if interfaces for
other sections might remain static?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
