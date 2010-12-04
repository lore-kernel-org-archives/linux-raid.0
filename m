From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Degraded Array
Date: Fri, 3 Dec 2010 20:42:27 -0600
Message-ID: <83.63.13137.69AA9FC4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone.

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 I was just growing one of my RAID6 ar=
rays from 13 to 14
members.=A0 The array growth had passed its critical stage and had been
growing for several minutes when the system came to a screeching halt.=A0=
 It
hit the big red switch, and when the system rebooted, the array assembl=
ed,
but two members are missing.=A0 One of the members is the new drive and=
 the
other is the 13th drive in the RAID set.=A0 Of course, the array can ru=
n well
enough with only 12 members, but it=92s definitely not the best situati=
on,
especially since the re-shape will take another day and a half.=A0 Is i=
t best
I go ahead and leave the array in its current state until the re-shape =
is
done, or should I go ahead and add back the two failed drives?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
