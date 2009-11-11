From: "Majed B." <majedb@gmail.com>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 08:22:26 +0300
Message-ID: <70ed7c3e0911102122l3565cfat7a35a8a649237f56@mail.gmail.com>
References: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
	<20091111034629287.IYTI6968@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111034629287.IYTI6968@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Leslie,

If you have a temporary space for your data, I'd suggest you move it
out and go for an internal bitmap solution. It certainly beats the
patch work you're going to have to do on the startup scripts (and
every time you update mdadm, or the distro).

On Wed, Nov 11, 2009 at 6:46 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> The mdadm-raid script starts up the
>> RAID process, and the mdadm script runs the monitor. =C2=A0It seems =
to me the
>> only link which is really correct is the rcS.d/S25mdadm. =C2=A0At th=
e very
>> least
>> I would think both the S99mdadm_monitor links should point to init.d=
/mdadm
>> (which, after all is the script which starts the monitor) and that
>> rc2.d/S25mdadm-raid would point to init.d/mdadm, just as the
>> rcS.d/S25mdadm-raid link does.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0'Sorry, I meant to say, "rc2.d/S25mdadm-ra=
id would point to
> init.d/mdadm-raid, just as the rcS.d/S25mdadm-raid link does." =C2=A0=
The naming
> convention here is definitely confusing.
>
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
