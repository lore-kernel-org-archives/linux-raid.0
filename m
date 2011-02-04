From: hansbkk@gmail.com
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 10:49:45 +0700
Message-ID: <AANLkTimGs4OnqMUozP4coaXXBkNJDA3DUyQmAEavgkP=@mail.gmail.com>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
	<20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<4D475AB5.10600@hardwarefreak.com>
	<20110203110428.GA26762@www2.open-std.org>
	<4D4B3DAE.3070502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4B3DAE.3070502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 4, 2011 at 6:43 AM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:
> Keld J=F8rn Simonsen put forth on 2/3/2011 5:04 AM:
>>> Unfortunately there is no organization, no standards body, that def=
ines RAID
>>> levels.
>
> Something smells bad here. =A0Does one of the RAID companies own a pa=
tent or
> trademark on "RAID 10"? =A0I'll look into this. =A0It just doesn't ma=
ke any sense
> for RAID 10 to be omitted from the SNIA DDF but to be referenced in t=
he manner
> it is.

=46or the sake of practical clarity, would it be possible for the list
to simply agree to use

RAID1+0  =3D the "outside-the-mdadm-world" meaning of RAID10

and something like

"md RAID10" for "our" RAID10

and to just not use plain "RAID10" at all, to avoid confusion

and move on?

Others more senior can of course propose other syntax; my goal is to
simply avoid the confusion caused by ambiguous terminology, and the
unnecessary friction that seems to come up every time these terms are
discussed.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
