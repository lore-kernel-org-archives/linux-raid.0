From: Durval Menezes <durval.menezes@gmail.com>
Subject: Unstable speed or correct?
Date: Thu, 9 Jun 2011 06:36:29 -0300
Message-ID: <BANLkTinrqCiyj+Z2zTAfS9Ar8MxUTn7Khw@mail.gmail.com>
References: <201106090909.23757.raid2@fuckaround.org>
	<BANLkTimbhe+qmTyVWKbRt6TZ9cynmmVNRw@mail.gmail.com>
	<201106091102.32709.raid2@fuckaround.org>
	<BANLkTimQ854noJpPEstnaG2CvsWvXFiWoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimQ854noJpPEstnaG2CvsWvXFiWoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid2@fuckaround.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Pol.

On Thu, Jun 9, 2011 at 6:02 AM, Pol Hallen <raid2@fuckaround.org> wrote=
:
>
> > What benchmark program did you use for the test? Also, was there an=
y other
> > programs running at the same time? Was the machine in single-user (=
init 1)
> > state?
>
> hello :-)
>
> dd if=3D/dev/zero of=3D/share/raid6/1Gb bs=3D1024 count=3D1000000
> 1000000+0 records in
> 1000000+0 records out
> 1024000000 bytes (1.0 GB) copied, 12.1632 s, 84.2 MB/s
>
> dd if=3D/dev/zero of=3D/share/raid6/10Gb bs=3D1024 count=3D10000000
> 10000000+0 records in
> 10000000+0 records out
> 10240000000 bytes (10 GB) copied, 142.021 s, 72.1 MB/s

The above dd's seem much more consistent than the graph.

> That graphic with palimptest (gnome-disk-utility).

I'm not familiar with this program (BTW, you mean "palimpsest",
right?), and I've run it for the first time on my system (M4A785-M
with Phenon-II X6 1055T, 4GB RAM, with 3 x ST31500541AS 1.5TB 3.5"
5900RPM HDs plugged directly onto the motherboard's SB700 SATA
controller, running Ubuntu Lucid Lynx 10.04.1 LTS, kernel
2.6.32-32-generic; the 3 HDs are mounted as a RAID5 md device and
dedicated to user data-only storage and mounted as /usr2, the root
filesystem runs on a separate SSD disk). Here's my palimpsest graph:
http://durval.com/felwithe_raid5_palimpsest_ro_20110609.jpg

Note that it shows much less "jitter" (local variation) than your graph=
=2E

> No other applications uses raid (I'm on init 2 but samba, ftp, and ot=
her
> daemons are off)
>
> iostat not show me any activity by raid, so I think there is not prog=
rams that
> runs on array.

This is very strange... concurrent access by other programs would
certainly explain the variation on your graph.

I would try running some other benchmark that can be run on
single-user state to see if the variation remains. If it does, then I
would conclude that there's something wrong (possibly on your
hardware, like a failing disk doing retries/reseeks).

Cheers,
--
=A0 Durval Menezes.


>
> thanks :-)
>
> Pol
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
