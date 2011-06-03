From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: 2.6.39: raid1 check blocks jbd on other md more than 120 seconds
Date: Fri, 3 Jun 2011 09:38:01 +0200
Message-ID: <20110603073801.GA30065@janus>
References: <20110602093644.GA8620@janus>
 <BANLkTimzMOo9uGjt-sDWPVBBdzSQaqVTWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimzMOo9uGjt-sDWPVBBdzSQaqVTWw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?utf-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 02, 2011 at 11:46:38AM +0200, Mathias Bur=C3=A9n wrote:
> On 2 June 2011 11:36, Frank van Maarseveen <frankvm@frankvm.com> wrot=
e:
> > The system runs FC14 with an (almost) stock 2.6.39 kernel, configur=
ed to
> > panic if it seems to hang. That's exactly what started to happen wi=
thout
> > anything being logged in the normal way except over netconsole.
> >
> > /proc/mdstat:
> > Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> > md3 : active raid1 sda3[0] sdb3[1]
> > =C2=A0 =C2=A0 =C2=A01885338488 blocks super 1.2 [2/2] [UU]
> >
> > md1 : active raid1 sda1[0] sdb1[1]
> > =C2=A0 =C2=A0 =C2=A033555384 blocks super 1.2 [2/2] [UU]
> >
> > kernel messages:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0(/etc/cron.weekly/99-raid-check kicks in=
)
> > Jun =C2=A02 04:04:00 janus md: data-check of RAID array md3
> > Jun =C2=A02 04:04:00 janus md: delaying data-check of md1 until md3=
 has finished (they share one or more physical units)
> > Jun =C2=A02 04:04:00 janus md: minimum _guaranteed_ =C2=A0speed: 10=
00 KB/sec/disk.
> > Jun =C2=A02 04:04:00 janus md: using maximum available idle IO band=
width (but not more than 200000 KB/sec) for data-check.
> > Jun =C2=A02 04:04:00 janus md: using 128k window, over a total of 1=
885338488 blocks.
> > Jun =C2=A02 04:55:54 janus INFO: task jbd2/md1-8:1188 blocked for m=
ore than 120 seconds.
> [...]
>=20
> Same behavior if you lower this?
>=20
> Jun  2 04:04:00 janus md: using maximum available idle IO bandwidth
> (but not more than 200000 KB/sec) for data-check.

Practical bandwidth is usually slightly more than 100MB/s at start
to approximately 60MB/s at the end of the disk. I tried setting
sync_speed_max at 70000kB/s. The problem seems to correlate with the
max. practical bandwidth because at the end of the data-check there wer=
e
a couple of hung task messages again, referring to postfix- and other
daemons this time. Timeline:

Jun  2 11:52:30 janus kernel: md: data-check of RAID array md3
Jun  2 11:52:30 janus kernel: md: using maximum available idle IO bandw=
idth (but not more than 70000 KB/sec) for data-check.
Jun  2 18:48:44 hung task
Jun  2 18:48:44 hung task
Jun  2 18:50:44 hung task
Jun  2 18:50:45 hung task
Jun  2 19:28:45 hung task
Jun  2 19:28:45 hung task
Jun  2 19:34:45 hung task
Jun  2 19:34:45 hung task
Jun  2 19:34:45 hung task
Jun  2 19:34:45 hung task
Jun  2 19:53:29 janus kernel: md: md3: data-check done.

Kernel has been booted with hung_task_panic=3D0.

--=20
=46rank
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
