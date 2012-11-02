From: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Subject: Re: mdadm recovery after HW failure: missing blocks at the end
Date: Fri, 2 Nov 2012 09:35:36 +0100
Message-ID: <C6751B14-E1F2-4673-8BB7-D2DACF66A1D8@tu-dresden.de>
References: <976F9B53-9E94-4684-B714-6F1FFD4FBFEF@tu-dresden.de>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <976F9B53-9E94-4684-B714-6F1FFD4FBFEF@tu-dresden.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hello all, hello Neil!

Am 01.11.2012 um 22:03 schrieb Sebastian Hegler:
> So, I've got two questions:=20
> * Did mdadm (or the kernel md driver) write to the end area of the di=
sk?
> * Is it possible to make mdadm give me back the 128kiB at the end of =
each device? There's 88kiB left on each disk; this used to be enough wh=
en I created the original array in 2010.
Let me clarify: there's still 88kiB left _after_ taking away 128kiB for=
 the chunk at the end.

Yours,
Sebastian
--
Dipl.-Inf. Sebastian Hegler
Wissenschaftlicher Mitarbeiter

Technische Universit=E4t Dresden
=46akult=E4t f=FCr Elektrotechnik und Informationstechnik
Lehrstuhl Hochfrequenztechnik
Helmholtzstr. 18
D-01062 Dresden

Tel.: +49 (0)351 463 35338
=46ax:  +49 (0)351 463 37163
Email: sebastian.hegler@tu-dresden.de

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
