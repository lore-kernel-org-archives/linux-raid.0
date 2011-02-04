From: hansbkk@gmail.com
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 18:15:44 +0700
Message-ID: <AANLkTi=8WLP9UJS895wgmWPgBSgxSGKUq+CLHfO9PGAp@mail.gmail.com>
References: <4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<4D475AB5.10600@hardwarefreak.com>
	<20110203110428.GA26762@www2.open-std.org>
	<4D4B3DAE.3070502@hardwarefreak.com>
	<20110204070613.GA3788@www2.open-std.org>
	<4D4BB87A.30800@hardwarefreak.com>
	<20110204090602.GA4017@www2.open-std.org>
	<4D4BCF3A.1030809@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4BCF3A.1030809@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 4, 2011 at 5:04 PM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:
> Keld J=F8rn Simonsen put forth on 2/4/2011 3:06 AM:

>> I dont think SNIA defines RAID 10, which is a specific Linux MD thin=
g.
>
> Either you're very young, or don't read what I type, maybe both. ;) =A0=
RAID 10 has
> been around for 15+ years. =A0It is not unique to Linux mdraid. =A0Th=
e "alternate
> layouts" of mdraid are unique to Linux/mdraid, but RAID 10 is not uni=
que to mdraid.
>
>> For RAID1+0, I think it is covered by the DDF standard
>
> RAID 10 and RAID 1+0 are the same thing by two different names. =A0It=
's not
>

> I'm getting dizzy from the running in circles...


Dope-slaps all 'round!

Again, this problem would just go away if everyone would just refrain
from using "RAID 10" or "RAID10" as if they were meaningful - within
the context of this list, they just cause confusion.

It seems the mdadm people are willing to use RAID 1+0 for "the other
kind", and the "outsiders" are willing to use "md RAID10", but both
sides would like to claim just plain "RAID10" for themselves, and it's
causing endless loops of non-communication!

Please reply with better alternatives, but IMO "md raid10" and
"raid1+0" are clear enough to be understood by one and all.

=46or those of you sick of my ranting on beating a dead horse, I'm sorr=
y
but I just can't help keeping on trying to put this behind us - we're
all here for a common cause aren't we?

I'm not asking you to change any religious beliefs outside the list,
just adopt an enabling convention for discussions here.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
