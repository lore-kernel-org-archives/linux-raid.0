From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 18:20:49 -0200
Message-ID: <AANLkTikEdnyV2uAdFxx7rWLjLurfHd_=kZnxf2O+1TU4@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
	<20110119064457.5ab8bdd0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119064457.5ab8bdd0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: for.poige+linux@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2)
If we have a filesystem + logical volume manager over raid device,
this could make less CPU/IO use
if we don=B4t have a filesystem, this could make less CPU/IO use

the question is, this really make more performace?
we don=B4t know, must benchmark with each filesystem, logical volume, d=
evice....
this is a good 'feature', but i don=B4t think we will get more
performace... (any benchmark to confirm it?)


2011/1/18 NeilBrown <neilb@suse.de>:
> On Tue, 18 Jan 2011 22:59:07 +0700 Igor Podlesny <for.poige+linux@gma=
il.com>
> wrote:
>
>> =A0 =A0I had experience of using FreeBSD's vinum (another software R=
AID).
>> Its author, Greg Lehey, stated in vinum's manual: "... A good
>> guideline for stripe size is between 256 kB and 512 kB. =A0Avoid pow=
ers
>> of 2, however: they tend to cause all superblocks to be placed on th=
e
>> first subdisk. ..."
>>
>> =A0 =A0Meanwhile, with LSR we're given exactly 2^n choices, for e. g=
=2E,
>> neither 768 KiB, nor 387 KiB won't go: "mdadm: invalid chunk/roundin=
g
>> value: 387".
>>
>> =A0 =A0So, why... ($Subj) and how complex would it be to abolish thi=
s
>> restriction? I think this could be a key to performance increase.
>>
>> =A0 =A0P. S. Thanks a ton for LSR, Neil, BTW. :-)
>>
>
> 1/ The rationale given by Greg for non-power-of-two chunk sizes is no=
t so
> =A0relevant for Linux I think. =A0The more common filesystems =A0can =
be told that
> =A0the device is a RAID and can deliberately offset the extra super b=
locks so
> =A0they don't all end up on the one device.
>
> 2/ Power-off-two is required simply because it was easier to code. =A0=
The
> =A0restriction was dropped for RAID0 a year or more ago. =A0The restr=
iction
> =A0could be dropped for RAID4/5/6 and RAID10 relatively easily. =A0It=
 would just
> =A0require a thorough code review and changing a few 'mask' and 'shif=
t'
> =A0operations to divisions.
>
> 3/ You are welcome.
>
> NeilBrown
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
