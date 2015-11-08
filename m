From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sun, 8 Nov 2015 09:20:11 -0500
Message-ID: <563F5A1B.30506@turmel.org>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com>
 <563E479E.50409@turmel.org>
 <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com>
 <563E685C.70208@turmel.org>
 <C57F2260-D20C-4688-93F6-CB3CE8CF9F30@abitofthisabitofthat.com>
 <563E843E.5060108@turmel.org>
 <251B709D-3310-433E-8817-E875194A69F9@abitofthisabitofthat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <251B709D-3310-433E-8817-E875194A69F9@abitofthisabitofthat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <cisco@abitofthisabitofthat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/08/2015 12:59 AM, Francisco Parada wrote:
>=20
>> Ok.  Those four drives cut out within a few milliseconds of each oth=
er.
> So I checked the enclosure=E2=80=99s PSU voltages, and it looks like =
the +5V rail was running at around +3V and the +12V rail at almost +8V =
under load.  So I think your original theory of there being a power iss=
ue is correct.  It=E2=80=99s a bummer, because I have 2 of these Rosewi=
ll 8-bay enclosures, and they both show that same issue.  This is very =
likely why they=E2=80=99ve been discontinued.  Granted the speed on the=
m is 1.5Gbps total per channel, but it=E2=80=99s really just for movies=
, so I=E2=80=99m not concerned about high speed read and writes.  I=E2=80=
=99ll just have to McGuyver it and use different PSUs than the ones the=
y came with.  I would imagine, that after about 500GB worth of data bei=
ng transferred, all the writing caused those drives to get pretty hot, =
making the PSU that much more likely to cut power.
> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816132016

I consider this *good* news :-)

>> Also, in the future, turn off word wrap when pasting. :-)
> Boom!  Done deal, there was a setting in my Apple Mail application un=
der Mail -> Preferences -> Fonts & Colors -> =E2=80=9CUse fixed-width f=
ont for plain text messages=E2=80=9D.  I think this might fix this word=
 wrap issue, so my apologies.  It=E2=80=99s either that, or the fact th=
at I copied and pasted directly from my Terminal application, and it co=
nverted the email to HTML, which changed the format.

Apple Mail? Eeeewwww!  :-)

In Thunderbird, word wrap is a separate setting.  You might want to
experiment a bit.

> Now, onto the butter.  I tried what you told me, and it showed that t=
he devices were busy:

Yeah, that's normal with partial successes.  Also, consider not using
md127.  That's mdadm's "I don't know what number to use" default.
(Followed by 126, then 125, as so on.)

> Then I tried it once again, but it seems that because they=E2=80=99re=
 displaying that the Events are out of sync, that it=E2=80=99s not able=
 to start the array.  Any ideas?

The --force option is supposed to override that.  I suspect since you
are running an old kernel, 3.19, you are also runnning an old mdadm.  I
recall some assemble bugs being fixed in the past few years.  Boot your
system temporarily with a rescue CD -- I recommend the one at
www.sysrescuecd.org -- that has current kernels and mdadm.  That'll let
you complete the assembly.  After that, with the array idle, a normal
shutdown will let your old kernel assemble it.

Consider upgrading your system when all is safe.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
