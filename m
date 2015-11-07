From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sat, 7 Nov 2015 18:07:42 -0500
Message-ID: <563E843E.5060108@turmel.org>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com>
 <563E479E.50409@turmel.org>
 <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com>
 <563E685C.70208@turmel.org>
 <C57F2260-D20C-4688-93F6-CB3CE8CF9F30@abitofthisabitofthat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C57F2260-D20C-4688-93F6-CB3CE8CF9F30@abitofthisabitofthat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <cisco@abitofthisabitofthat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2015 05:18 PM, Francisco Parada wrote:

> So it looks like /var/log/syslog is where it=E2=80=99s storing those =
values,
> I=E2=80=99ve included the full log for that day (gzip attached), but =
for
> completion, here are the times I see dropped drives first start happe=
ning:

[trim /]

Ok.  Those four drives cut out within a few milliseconds of each other.

>> However, it is clear from these reports that you are in fact sufferi=
ng
>> from timeout mismatch:

> Thanks, I didn=E2=80=99t realize that.  Here is my command, because y=
our=E2=80=99s
> wasn=E2=80=99t giving me the mdadm portion for some reason:

Because I do all such maintenance as root.  In an ubuntu system, use
"sudo su -" to get a full root console.

[trim /]

Also, in the future, turn off word wrap when pasting. :-)

> Thanks, I=E2=80=99ll mount those and circle back.  I=E2=80=99m going =
to head out due to
> a family dinner, so I=E2=80=99ll circle back once I=E2=80=99m done.  =
Once again, thank
> you kindly for your insight!!!

No hurry.  And you're welcome.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
