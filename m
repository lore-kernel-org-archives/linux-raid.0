From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sat, 7 Nov 2015 16:08:44 -0500
Message-ID: <563E685C.70208@turmel.org>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com>
 <563E479E.50409@turmel.org>
 <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <cisco@abitofthisabitofthat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2015 02:17 PM, Francisco Parada wrote:
> Hi Phil,
>=20
> First, I want to thank you for taking the time to reply to me, I trul=
y appreciate it.  Secondly, I must correct my statement =E2=80=9CI adde=
d two new arrays to my system last night=E2=80=9D =E2=80=A6 I had start=
ed writing this email a few nights ago, and shut down the system in ord=
er to prevent me from getting frustrated and doing something stupid.  S=
o I walked away from all of it, and just forgot to amend my original em=
ail.  So the system was off for a few days, and I turned it back on a f=
ew minutes before sending my email, and dmesg only shows today=E2=80=99=
s output, and interestingly enough, no timestamps are on there.

That's ok.  I was looking at the last update times on your mdadm -E rep=
orts.

>> 1) the dmesg from the time around the event, +/- a few minutes.
>=20
> Having said that, dmesg isn=E2=80=99t showing me anything from that d=
ay either, and I just found out that /var/log/messages doesn=E2=80=99t =
even exist in my Ubuntu Server 15.04.  It seems I have to enable that, =
so that=E2=80=99s one more thing I=E2=80=99m about to do now.  Are ther=
e any other ways I could possibly retrieve that?  I=E2=80=99m afraid th=
e answer will be a solid =E2=80=9Cno=E2=80=9D, but worth asking.

Hmm.  Did Ubuntu switch to systemd for that version?  If so, you'll nee=
d to use journalctl.  I'm only now learning that, so you'll have to res=
earch the options you need yourself.  Or others here on the list will c=
hime in :-)

>> 2) the output of the following drive diagnostics:
>>
>> for x in /dev/sd[a-z] ; do echo $x ; smartctl -i -A -l scterc $x ; d=
one

You cut off the "echo $x" part.  I very much wanted that to document wh=
ich drives were which serial numbers.

If you want to be pedantic, combine mdadm -E and smartctl instead:

for x in /dev/sd[a-z] ; do mdadm -E $x ; smartctl -i -A -l scterc $x ; =
done

However, it is clear from these reports that you are in fact suffering =
from timeout mismatch:


> SCT Error Recovery Control:
>            Read: Disabled

> SCT Error Recovery Control command not supported

> SCT Error Recovery Control command not supported

> SCT Error Recovery Control command not supported

> SCT Error Recovery Control command not supported

> SCT Error Recovery Control command not supported

> SCT Error Recovery Control command not supported

> SCT Error Recovery Control command not supported

You will need to apply the workarounds for these drives.  The one with =
scterc disabled is a raid-capable drive that just powers up in desktop =
mode.  Add "smartctl -l scterc,70,70 /dev/sdX" to your boot scripts for=
 that one.  For the others, you will need to set a long timeout.  For n=
ow, before any more mdadm operations, just use the blanket work-around =
script:

for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

Now, I didn't see any "Current Pending Sector" counts, so I don't think=
 you are suffering from UREs.  In fact, with four of your drives dying =
together, I suspect you overloaded your power supply(ies) with the extr=
a arrays, either electrically or thermally.  The power was OK for idle =
and trivial operations but couldn't handle the load while copying.

Backup across a gigabit lan if you can't get all the necessary drives i=
nto the main case.

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>> Do *not* perform any --create operation on your array.
> No worries, I=E2=80=99m not touching that.  Thank you for your input.

At this point, I'm confident that your complete set of original drives =
should just be forcibly assembled:

mdadm -Afv /dev/mdX /dev/sd[b-h]

Replace the device letters if they've changed since your mdadm -E repor=
ts.

There might be minor filesystem damage if any blocks were in flight to =
the array when it died.  fsck, then mount.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
