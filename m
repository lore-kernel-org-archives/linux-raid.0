From: "Majed B." <majedb@gmail.com>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Thu, 10 Sep 2009 12:39:21 +0300
Message-ID: <70ed7c3e0909100239h208a6f9dlc8343774416e6f1a@mail.gmail.com>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
	<slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org> <20090908184837.GA28217@teal.hq.k1024.org>
	<4AA70604.7020709@harddata.com> <ABFC24E4C13D81489F7F624E14891C860D4C3553@uk-ex-mbx1.terastack.bluearc.com>
	<slrnhaf2ub.2i5.Mario.Holbe@darkside.dyn.samba-tng.org> <ABFC24E4C13D81489F7F624E14891C860D4C3894@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ABFC24E4C13D81489F7F624E14891C860D4C3894@uk-ex-mbx1.terastack.bluearc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

sdparm is similar to hdparm but meant to deal with SCSI devices
(including SATA).

Your repository should have it, or download & compile.

On Thu, Sep 10, 2009 at 12:26 PM, Simon Jackson<sjackson@bluearc.com> w=
rote:
> Hmmm. =C2=A0I do not have sdparm on my system.
>
> Linux 2.6.26-1-amd64 #1 SMP Sat Jan 10 17:57:00 UTC 2009 x86_64 GNU/L=
inux
>
> Is this the same functionality as the hdparm utility?
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Mario 'BitKoenig' Holbe
> Sent: 09 September 2009 12:05
> To: linux-raid@vger.kernel.org
> Subject: Re: mdadm and TLER (Time Limited Error Recovery)
>
> Simon Jackson <sjackson@bluearc.com> wrote:
>> In my case I am using Seagate and Hitachi drives.
>> Please can anyone tell me how I would go about setting timeout value=
s on these types of drive. Are there utility programs to do this or a L=
inux
>
> Well, my Seagates have a RTL (Recovery time limit (ms)) field in the =
rw
> (Read write error recovery) mode page.
>
> You could try something like `sdparm -W RTL=3D7000 /dev/sdX' to set i=
t to
> 7 seconds. I don't know if it works, I didn't test it, use it at your
> own risk! Do a backup before, it could blow up your disk or even the
> universe :) Tell us if it worked :)
>
>
> regards
> =C2=A0 Mario
> --
> () Ascii Ribbon Campaign
> /\ Support plain text e-mail
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
