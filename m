From: Marco Schindler <marco.schindler@gmail.com>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Fri, 12 Sep 2014 00:45:20 +0200
Message-ID: <164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com> <20140912082403.549fc298@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140912082403.549fc298@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12.09.2014, at 00:24, NeilBrown <neilb@suse.de> wrote:

> On Fri, 12 Sep 2014 00:05:08 +0200 Marco Schindler
> <marco.schindler@gmail.com> wrote:
>=20
> In that bug report you mention upgraded udev.  Here you mention upgra=
ding
> mdadm.... a bit confusing.

totally unsure if this is related, it may be coincidence.=20
just found it=92s odd to have a similar issue with two different proces=
ses in such a short timeframe.

I have blocked >sys-fs/udev-212 and >sys-fs/mdadm-3.2 for now to give d=
rives some rest.

> Can you use "blktrace" to gather details on exactly what is being rea=
d and
> when, and  hopefully which process is doing it?
>=20
> Is "mdadm --monitor" (or "-F") running?  If you kill it does the disk
> activity go away?
>=20
> NeilBrown

yes I have (and have been) running "mdadm --monitor --scan =97daemonise=
"
I have /proc/sys/vm/block_dump enabled and it shows process mdadm acess=
ing drives every 15 minutes.

I wouldn=92t be aware of mdadm being invoked elsewhere, so I presume it=
 won=92t happen when daemon is not running.
Will see if I can get some more info with blktrace and report back..



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
