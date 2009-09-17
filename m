From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid5 Read stats for parity cal...
Date: Thu, 17 Sep 2009 03:20:19 +0300
Message-ID: <70ed7c3e0909161720r5a068ca4m8335cfbbd51bc220@mail.gmail.com>
References: <f5d1f90a0909161713s2f31e3b4t34a4ee285b83ef8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909161713s2f31e3b4t34a4ee285b83ef8e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can force an array check by writing "check" (without double
quotes) to a file named "sync_action" found in /proc/sys

Read this for further details: http://linux.die.net/man/4/md

You can run that check at any time, not just when there's a problem.

On Thu, Sep 17, 2009 at 3:13 AM, Linux Raid Study
<linuxraid.study@gmail.com> wrote:
> Hello:
>
> I understand that parity calculations are not done as part of Raid5
> read operation in normal running conditions.
>
> However, it would be done during disk failure or when a sector is bad=
=2E
> Is there a way (any stats) available to see if parity cal are done
> when sector is bad (since this is not as obvious as a disk fail...)
>
> Thanks!
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
