From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Wed, 3 Nov 2004 23:56:20 -0000 (GMT)
Message-ID: <38038.212.158.231.74.1099526180.squirrel@mail.fsck.co.uk>
Reply-To: james@fsck.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I'd like to put raid6 to use, and after reading through the process of
tracking down this bug, it seems that a rational explanation was found =
for
the data corruption, and the fix well tested... but being new to a lot =
of
the process here, what is the process for this to get into the standard
kernel... perhaps 2.6.10 will have this patch??

Obviously I could apply the patch to raid6main.c on my system, but it
would be  good to use a standard kernel...

The problem is only when writing to a degraded array, but most of us ar=
e
impatient and want to write a filesystem and get it mounted before the
first sync is complete... and those, like me cursed with bad hardware w=
ill
have 2 drives fail at the same time (last week!) and hence raid6 is ver=
y
appealing :).

--=20
=AF=B7.=B8=B8.=B7=B4=AF=B7.=B8=B8.-> A. James Lewis (james@fsck.co.uk)
http://www.fsck.co.uk/personal/nopistons.jpg
MAZDA - World domination through rotary power.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
