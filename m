From: Steven Ihde <sihde@cs.stanford.edu>
Subject: Re: 2.6.0: ext3 journal aborted with ext3/lvm/raid5
Date: Thu, 19 Feb 2004 13:08:05 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040219210805.GA576@hamachi.dyndns.org>
References: <20040107205326.GA14511@hamachi.dyndns.org> <pan.2004.02.18.14.55.50.11785@dutra.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <pan.2004.02.18.14.55.50.11785@dutra.fastmail.fm>
To: Leandro =?utf-8?Q?Guimar=C3=A3es?= Faria Corsetti Dutra <leandro@dutra.fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 18, 2004 at 11:55:50AM -0300, Leandro Guimar=C3=A3es Faria =
Corsetti Dutra wrote:
> On Wed, 07 Jan 2004 12:53:26 -0800, Steven Ihde wrote:
>=20
> > I get "Aborting journal on device dm-x" and associated errors about=
 every
> > week or two.  This is on a 2.6.0 kernel, ext3 filesystem running on=
 lvm
> > over md raid5.
>=20
> 	I've found a similar situation, have any fix came forth?

=46unny you should bring it up now.  When I posted back in January it
was suggested that I verify my hardware/memory was OK and also try to
reproduce the bug on 2.4.24.  So, I ran burnBX/burnMMX for a couple
days, turned up no problems, did memtest86 overnight, also no
problems, and then I switched to 2.4.24.

I ran 2.4.24 (plus dm-1.00.07 for lvm2) for about 25 days and had no
problems.  This seemed like reasonable evidence the problem doesn't
exist (or takes longer to show up) in 2.4.24.  So then I switched to
2.6.2 (that being the latest 2.6 kernel).  After about six days uptime
on 2.6.2, I started seeing the problem again.

Can anyone suggest what the next step is? =20

Here are the latest entries from my syslog (this is 2.6.2).  As it
usually does, this occurred early in the morning while the locatedb
was being updated.

=46eb 14 06:12:44 hamachi kernel: EXT3-fs error (device dm-4): ext3_rea=
ddir: bad entry in directory #5160995: rec_len is smaller than minimal =
- offset=3D0, inode=3D0, rec_len=3D0, name_len=3D0
=46eb 14 06:12:44 hamachi kernel: Aborting journal on device dm-4.
=46eb 14 06:12:45 hamachi kernel: ext3_abort called.
=46eb 14 06:12:45 hamachi kernel: EXT3-fs abort (device dm-4): ext3_jou=
rnal_start: Detected aborted journal
=46eb 14 06:12:45 hamachi kernel: Remounting filesystem read-only
=46eb 14 06:13:56 hamachi kernel: EXT3-fs error (device dm-4) in start_=
transaction: Journal has aborted
=46eb 14 06:13:57 hamachi last message repeated 741 times

Thanks,

Steve


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
