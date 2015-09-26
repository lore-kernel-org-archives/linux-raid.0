From: Phil Turmel <philip@turmel.org>
Subject: Re: Unable to assemble RAID6 after Ubuntu>Arch switch
Date: Sat, 26 Sep 2015 07:33:20 -0400
Message-ID: <56068280.2090009@turmel.org>
References: <CADNH=7Hr6HXVPQP6-V8Jkr9aSwqHojoWApjA7ZKnQOPL0inUYw@mail.gmail.com>
 <CAETWcfsw2M3JkNmE3M3nsr0_M4N86ta+kaRo62OgK+Ft0J5iiw@mail.gmail.com>
 <CADNH=7E796sv+A4PDb2n=EJomAR8KPRoGt-=+52BYfrELBFZDg@mail.gmail.com>
 <CAETWcfvF1o8mNVw1t-=7WNZZTz774eTnj1tG6UckrXbDvWxdXg@mail.gmail.com>
 <CADNH=7Eyy-K3ivHAt_oYtTWdkeSDA7itZ+1Y+-EHdz8Y9_U0ww@mail.gmail.com>
 <CAETWcftkkJr_MjP5ReBsOCW5ioCu81KQcdwr_1-=qUD25e1ssw@mail.gmail.com>
 <CADNH=7HEpag54Z7+aey+skWiThL93H2sgPpxVS77pqp4R_1NAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HEpag54Z7+aey+skWiThL93H2sgPpxVS77pqp4R_1NAQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Mathias_Bur=c3=a9n?= <mathias.buren@gmail.com>, Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/26/2015 08:16 AM, Mathias Bur=C3=A9n wrote:
> Hi,
>=20
> Would it be possible to somehow manually assemble array under Arch?
> Since the Arch kernel doesn't see /dev/sda1 and /dev/sdb1 (fdisk sees
> them but they do not appear in /dev) I can't assemble arrays.
> partprobe doesn't help. Any ideas why the partitions wouldn't populat=
e in /dev ?

Is there any chance you've managed to get a GPT label onto those disks?
 And your arch kernel has omitted GPT support?

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
