From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: raid bug in 2.4.20
Date: Fri, 11 Apr 2003 11:13:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030411091336.GE17163@marowsky-bree.de>
References: <Pine.LNX.4.44.0304101623300.25209-100000@karma.hagopian.net> <3.0.6.32.20030411102033.00bafcd0@athen>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20030411102033.00bafcd0@athen>
To: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>, Paul Clements <Paul.Clements@SteelEye.com>, Rob Hagopian <rob@hagopian.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-04-11T10:20:33,
   Alfred Isele <Alfred.Isele@fujitsu-siemens.com> said:

> After rebooting the resynch really starts.
> Moreover sometimes after detaching (... -f ... -r ...)
> I have either raid1d or mdrecoveryd=20
> obviously looping uninterruptible on a CPU.=20

Hrm. I've not had that happen to me, but it would be nice if you could =
provide
sysrq-t output would be helpful.

What happens if you mdadm -S the array? What is the mdadm --detail stat=
us?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
