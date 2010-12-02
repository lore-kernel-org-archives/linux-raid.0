From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: turn off auto assembly
Date: Thu, 2 Dec 2010 22:16:25 +0100
Message-ID: <slrnifg359.9qh.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <4CF7F369.4090303@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmenau.de> wrote:
> Now I have the effect that upon plugging in drives that formerly were
> part of an array, the md_mod modules gets loaded and tries to
> auto-assemble arrays.  This disturbs the diagnosis.
> I've tried raid=3Dnoautodetect as kernel commandline, and I grepped t=
he
> source for the MODULE_PARM_DESC macro, which yielded no (useful) resu=
lt.
>  This "automagic" behaviour happens since 2.6.36.

Are you sure this autodetection is triggered by the module?
And are you sure this behaviour is bound to this specific kernel
version?

In-Kernel auto-assembly is usually not active when md is compiled as
module. Probably in your case this is some udev-triggered assembly?


regards
   Mario
--=20
Programmieren in C++ haelt die grauen Zellen am Leben. Es schaerft
alle fuenf Sinne: den Schwachsinn, den Bloedsinn, den Wahnsinn, den
Unsinn und den Stumpfsinn.
                                 [Holger Veit in doc]

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
