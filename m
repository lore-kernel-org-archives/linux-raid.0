From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: mkraid with 2.6.0
Date: Fri, 9 Jan 2004 11:42:41 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401091642.i09Ggji05421@dns1.watkins-home.com>
References: <20040109145547.B19523@beton.cybernet.src>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040109145547.B19523@beton.cybernet.src>
To: =?iso-8859-1?Q?'Karel_Kulhav=FD'?= <clock@twibright.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a similar problem when I added more disks to my system.
Learn and mdadm!

Start here:
man mdadm

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Karel Kulhav=FD
Sent: Friday, January 09, 2004 8:56 AM
To: linux-raid@vger.kernel.org
Subject: mkraid with 2.6.0

bash-2.05b# mkraid /dev/md0
/dev/md1: array is active -- run raidstop first.
mkraid: aborted.
(In addition to the above messages, see the syslog and /proc/mdstat as =
well
 for potential clues.)

It seems like mkraid from raidtools-1.00.3 doesn't work with 2.6.0 kern=
el.
I want it to make /dev/md0 and it tell me /dev/md1 is active - /dev/md1
is active, but it is not a reason to refuse to work.

Cl<
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
