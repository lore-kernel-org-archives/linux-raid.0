From: Flynn <flynn@kodachi.com>
Subject: Solved! (was Re: RAID6 Reshape (one more time))
Date: Sat, 11 Aug 2012 23:47:47 -0400
Message-ID: <980CE3239B1B4E7215C9CE30@ryoohko.kodachi.com>
References: <71AEA6EFEB86AE9F3D4990D4@ryoohko.kodachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <71AEA6EFEB86AE9F3D4990D4@ryoohko.kodachi.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> So at this point I have partitions 5, 6, and 7 happy; 8 - 14 are mark=
ed
> inactive...

NeilBrown was kind enough to offer some advice.  Here's the short versi=
on,=20
for anyone who runs across this searching:

1) Yes, metadata version 0.91 is OK, it just means a reshape is pending=
=2E

2) Mismatches in 'this' are most likely due to probe ordering changes; =
no=20
problem.

3) The most likely cause for a failure like this if you know that the=20
critical section was passed, and the checksums etc. are consistent, is=20
simply that the backup of the critical section is too old:

3a) mdadm -A -v will confirm that the issue is that the backup is too o=
ld:=20
it will say 'too-old timestamp on backup-metadata on xxxx' and, indeed,=
=20
that was my issue.

3b) export MDADM_GROW_ALLOW_OLD=3D1 will allow mdadm -A to use the old =
backup=20
anyway.

=2E..and I'm happy to report that that worked just fine.  I was using m=
dadm=20
3.2.5 for this; I don't know if 3.2.3 (which Ubuntu 12.04 ships with)=20
supports MDADM_GROW_ALLOW_OLD.

Thanks, Neil!

 -- Flynn

--
=D0=A6=D0=B5=D1=80=D0=BA=D0=BE=D0=B2=D1=8C =D0=B1=D0=BB=D0=B8=D0=B7=D0=BA=
=D0=BE, =D0=BD=D0=BE =D0=B4=D0=BE=D1=80=D0=BE=D0=B3=D0=B0 =D0=BE=D1=87=D0=
=B5=D0=BD=D1=8C=20
=D1=81=D0=BA=D0=BE=D0=BB=D1=8C=D0=B7=D0=BA=D0=B0=D1=8F; =D0=BF=D0=B8=D0=
=B2=D0=BD=D1=83=D1=88=D0=BA=D0=B0 =D0=B4=D0=B0=D0=BB=D0=B5=D0=BA=D0=BE,=
 =D0=BD=D0=BE =D1=8F =D0=B1=D1=83=D0=B4=D1=83 =D0=B8=D0=B4=D1=82=D0=B8
=D0=BE=D1=81=D1=82=D0=BE=D1=80=D0=BE=D0=B6=D0=BD=D0=BE.                =
                                (Yakov=20
Smirnoff)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
