From: Drew <drew.kay@gmail.com>
Subject: Re: What's the typical RAID10 setup?
Date: Sat, 5 Feb 2011 19:59:35 -0800
Message-ID: <AANLkTinMD6uFJf1norPTQZ=8fYN0NmoJTPyQLBLXrNbK@mail.gmail.com>
References: <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
 <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
 <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org>
 <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org>
 <4D4BB87A.30800@hardwarefreak.com> <20110204090602.GA4017@www2.open-std.org>
 <20110204204251.GB6603@www2.open-std.org> <4D4C6C7B.2020304@hardwarefreak.com>
 <20110204220507.GA6876@www2.open-std.org> <4D4C85D3.2030903@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4C85D3.2030903@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> No, it's not. =C2=A0I see no mention of "RAID 1+0" anywhere in SNIA d=
ocuments. =C2=A0I
> _do_ see "RAID 10" casually mentioned in many places in their documen=
ts. =C2=A0But
> I've yet to find where they define or bother to minimally explain the=
 term "RAID
> 10". =C2=A0In technical writing you must define something before you =
discuss or
> reference it.

It's not explicitly defined but it's there.

Page 84, Section 4.3 Secondary RAID Level

"Table 15 lists values used in the Secondary_RAID_Level field of the
Virtual Disk Configuration Record
(Section 5.9.1) and their definitions. The table defines secondary
RAID levels such as Striped, Volume
Concatenation, Spanned, and Mirrored for hybrid or multilevel virtual
disks. The Secondary_RAID_Level
field in the Virtual Disk Configuration Record MUST use the values
defined in Table 15."

It then goes on to describe how the various secondary RAID levels are
composed of "Basic Virtual Disks" (their term for RAID arrays
presented as single disks.)

As a somewhat related aside I ran into this on an IBM x3650 I was
configuring for an office a few months back. IBM explicitly stated
support for RAID 10 but the process for setting up the RAID 10 array
involved setting up a pair of mirrored disks which the RAID controller
then recognized as components it could use to build a RAID 10 array.

Reading through the SNIA document and noting IBM & LSI's involvement
made me think they may be using the DDF specs in their arrays, which
might explain why setting up a RAID 10 array was such an involved
affair.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
