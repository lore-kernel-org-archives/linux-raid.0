From: piergiorgio.sartor@nexgo.de
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 19 Dec 2008 09:40:46 +0100 (CET)
Message-ID: <33141855.1229676046422.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

thanks for the answer.
I've still some comments on the topic, see below.

> Suppose we agree that bit flips don't happen (undetected) on drive
> media.  But that bit flips can happen elsewhere (memory.  IO Buss
> etc).
>=20
> And then suppose we discover that a bit-flip has happened.  What does
> that tell us?
> Maybe it tells us that our hardware is dodgey.  So it cannot be
> trusted to reliably do anything we tell it.  So maybe we shouldn't
> tell it to do anything. ??

Maybe I should try to clarify the concept.
There are *two* use cases.
One is the "check" and one is the "repair".
As I already wrote, I do agree that "repair" needs some deeper
thinking. It is easy to see cases where it could produce more
damages.
The "check" case is another story.
In case of RAID-6 I would like, as RFE, to have in the logs some
report on which "drive" or "data path" the mismatch occurs, when
detectable.
So, if the mismatch count says there are 1024 mismatches, then
would be nice to know if they belong all to the same drive or not.
In this case, it would be possible to fail/remove that one and
check the hardware (change drive/cable/connector/etc.).

Ideally, at the end of the "check", the log should report how
many mismatches, how many are "undeterminable" (multiple
drive), how many could belong to a specific drive.
This will help to to diagnose a problem, maybe reported by
the CRC in the filesystem.

This is for the "check", about the "repair", the only possible
change I could see is to offer the user, and we could check
in this mailing list how many would like to have the possibility,
the option to "reset the parity" of the array or "recalculate the
data", with the warning that the second one can do more
damage than already has.

Conclusion, for me, is that the "check" should be more
clever, with RAID-6, and "repair/resync" *might* be more
flexible (with warnings).

I take the opportunity to wish you all Merry Christmas
and Happy New Year.

bye,

--=20

pg


Jetzt komfortabel bei Arcor-Digital TV einsteigen: Mehr Happy Ends, meh=
r Herzschmerz, mehr Fernsehen! Erleben Sie 50 digitale TV Programme und=
 optional 60 Pay TV Sender, einen elektronischen Programmf=FChrer mit M=
ovie Star Bewertungen von TV Movie. Au=DFerdem, aktuelle Filmhits und s=
pannende Dokus in der Arcor-Videothek. Infos unter www.arcor.de/tv
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
