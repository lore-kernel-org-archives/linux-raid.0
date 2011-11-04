From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 09:09:05 -0600
Message-ID: <201111040909.06005.thomas@fjellstrom.ca>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com> <CALJXSJouyQxMcV_CKGUiU-QkzDor2FTW25uGFyy-jDLnppnoAg@mail.gmail.com> <CALJXSJrZziXeJa5q20KHTaM3rw3c1KU=L_pU2hLJ=km-Kh1fbQ@mail.gmail.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJrZziXeJa5q20KHTaM3rw3c1KU=L_pU2hLJ=km-Kh1fbQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?q?J=C3=A9r=C3=B4me_Poulin?= <jeromepoulin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On November 4, 2011, J=C3=A9r=C3=B4me Poulin wrote:
> On Fri, Nov 4, 2011 at 9:57 AM, Mathias Bur=C3=A9n <mathias.buren@gma=
il.com>=20
wrote:
> > Basically, if uncorrectable sectors >0 or pending sectors >0 the dr=
ive
> > is failing. So replace ASAP :)
>=20
> Exactly, with the new drives, they try to hide errors as much as they
> can, as soon as SMART shows anything suspect, READ DMA failures,
> pending sectors, offline uncorrectable sectors, or any tests fail, th=
e
> disk is going to die soon.

Maybe I was just lucky, but I had an uncorrectable sector error at one =
point,=20
and ran a dd write on the drive, and SMART reported the sectors were=20
corrected. It wouldn't do it with a read, but a full write worked. The =
drive=20
worked for quite some time after that. I might still have it, but I can=
't=20
remember which drive that was (I've had a lot).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Thomas Fjellstrom
thomas@fjellstrom.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
