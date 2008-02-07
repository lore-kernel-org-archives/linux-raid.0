From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: recommendations for stripe/chunk size
Date: Thu, 7 Feb 2008 10:58:25 +0100
Message-ID: <20080207095825.GB7674@rap.rap.dk>
References: <47AA08E7.5000801@tmr.com> <20080206202536.3316124D1D@gemini.denx.de> <20080207003116.GA23341@rap.rap.dk> <20080207054012.GA17705@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080207054012.GA17705@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 07, 2008 at 06:40:12AM +0100, Iustin Pop wrote:
> On Thu, Feb 07, 2008 at 01:31:16AM +0100, Keld J=F8rn Simonsen wrote:
> > Anyway, why does a SATA-II drive not deliver something like 300 MB/=
s?
>=20
> Wait, are you talking about a *single* drive?

Yes, I was talking about a single drive.

> In that case, it seems you are confusing the interface speed (300MB/s=
)
> with the mechanical read speed (80MB/s).

I thought the 300 MB/S was the transfer rate between the disk and the
controllers memory in its buffers, but you indicate that this is the
speed between the controller's buffers and main RAM.=20

I am, as Neil, amazed by the speeds that we get on current hardware, bu=
t
still I would like to see if we could use the hardware better.
Asyncroneous IO could be a way forward. I have written some mainframe
utilities where asyncroneous IO was the key to the performance,
so I thought that it could also become handy in the Linux kernel.=20

If about 80 MB/s is the maximum we can get out of a current SATA-II
7200 rpm drive, then I think there is not much to be gained from
asyncroneous IO.=20

> If you are asking why is a
> single drive limited to 80 MB/s, I guess it's a problem of mechanics.
> Even with NCQ or big readahead settings, ~80-~100 MB/s is the highest
> I've seen on 7200 RPM drives. And yes, there is no wait until the CPU
> processes the current data until the drive reads the next data; drive=
s
> have a builtin read-ahead mechanism.
>=20
> Honestly, I have 10x as many problems with the low random I/O through=
put
> rather than with the (high, IMHO) sequential I/O speed.

I agree that random IO is the main factor on most server installations.
But on workstations the sequentioal IO is also important, as the only
user is sometimes waiting for the computer to respond.
And then I think that booting can benefit from faster sequential IO.
And not to forget, I think it is fun to make my hardware run faster!

best regards
Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
