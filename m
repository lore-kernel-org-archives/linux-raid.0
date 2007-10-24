From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Wed, 24 Oct 2007 16:49:28 -0700
Message-ID: <e9c3a7c20710241649qb26c36by5733a93cff394c40@mail.gmail.com>
References: <4714BB92.7040701@systella.fr> <471864F8.9010209@systella.fr>
	 <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>
	 <4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr>
	 <47191855.4020402@systella.fr> <47191BCF.2000908@systella.fr>
	 <1192828331.30976.26.camel@dwillia2-linux.ch.intel.com>
	 <4719B6DE.9040403@systella.fr> <471EF07A.5040007@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471EF07A.5040007@systella.fr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, Ming Zhang <blackmagic02881@gmail.com>
List-Id: linux-raid.ids

On 10/24/07, BERTRAND Jo=EBl <joel.bertrand@systella.fr> wrote:
>         Hello,
>
>         Any news about this trouble ? Any idea ? I'm trying to fix it=
, but I
> don't see any specific interaction between raid5 and istd. Does anyon=
e
> try to reproduce this bug on another arch than sparc64 ? I only use
> sparc32 and 64 servers and I cannot test on other archs. Of course, I
> have a laptop, but I cannot create a raid5 array on its internal HD t=
o
> test this configuration ;-)
>

Can you collect some oprofile data, as Ming suggested, so we can maybe
see what md_d0_raid5 and istd1 are fighting about?  Hopefully it is as
painless to run on sparc as it is on IA:

opcontrol --start --vmlinux=3D/path/to/vmlinux
<wait>
opcontrol --stop
opreport --image-path=3D/lib/modules/`uname -r` -l

--
Dan
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
