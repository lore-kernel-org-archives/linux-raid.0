From: Iustin Pop <iusty@k1024.org>
Subject: Re: recommendations for stripe/chunk size
Date: Thu, 7 Feb 2008 06:40:12 +0100
Message-ID: <20080207054012.GA17705@teal.hq.k1024.org>
References: <47AA08E7.5000801@tmr.com> <20080206202536.3316124D1D@gemini.denx.de> <20080207003116.GA23341@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080207003116.GA23341@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?utf-8?B?SsO4cm4=?= Simonsen <keld@dkuug.dk>
Cc: Wolfgang Denk <wd@denx.de>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 07, 2008 at 01:31:16AM +0100, Keld J=C3=B8rn Simonsen wrote=
:
> Anyway, why does a SATA-II drive not deliver something like 300 MB/s?

Wait, are you talking about a *single* drive?

In that case, it seems you are confusing the interface speed (300MB/s)
with the mechanical read speed (80MB/s). If you are asking why is a
single drive limited to 80 MB/s, I guess it's a problem of mechanics.
Even with NCQ or big readahead settings, ~80-~100 MB/s is the highest
I've seen on 7200 RPM drives. And yes, there is no wait until the CPU
processes the current data until the drive reads the next data; drives
have a builtin read-ahead mechanism.

Honestly, I have 10x as many problems with the low random I/O throughpu=
t
rather than with the (high, IMHO) sequential I/O speed.

regards,
iustin
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
