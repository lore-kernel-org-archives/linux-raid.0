From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: turn off auto assembly
Date: Thu, 02 Dec 2010 20:28:41 +0100
Message-ID: <4CF7F369.4090303@stud.tu-ilmenau.de>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi List,

i have multiple technicians computers where I need the md-modules f.e.
for recoveries and such.  But these computers are also used to just
diagnose failing drives.

Now I have the effect that upon plugging in drives that formerly were
part of an array, the md_mod modules gets loaded and tries to
auto-assemble arrays.  This disturbs the diagnosis.

I've tried raid=noautodetect as kernel commandline, and I grepped the
source for the MODULE_PARM_DESC macro, which yielded no (useful) result.
 This "automagic" behaviour happens since 2.6.36.

Is there any way to turn it off - i.e. that I need to explicitly issue
mdadm commands to bind any drive to any array?

Cheers,
Stefan
