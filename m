From: Jared Mauch <jared@puck.nether.net>
Subject: Re: (R) in mdstat output, clean && degraded
Date: Tue, 23 Jun 2015 18:23:26 -0400
Message-ID: <61AC9B93-4EB6-49A1-B08A-43D2617AEAD1@puck.nether.net>
References: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net> <5589BDCA.5050801@turmel.org> <F30009F6-7BF5-4786-A3A6-04C5C49B8E0C@puck.nether.net> <5589D918.9000401@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5589D918.9000401@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


> On Jun 23, 2015, at 6:09 PM, Phil Turmel <philip@turmel.org> wrote:
>=20
> On 06/23/2015 05:21 PM, Jared Mauch wrote:
>> Let me know what debugging/details might be interesting to collect. =
=20
>=20
> A good sequence of events (from bash history perhaps) with correspond=
ing
> log messages is always helpful.  Your initial report was pretty good.

I looked, this seems to have aged out.  Plus, bash.. meh.. tcsh :)

>> Based on the Events# being in-sync, I am going to assume that the dr=
ives
>> may be operating in a protected-type mode even if the output doesn=E2=
=80=99t
>> concur.
>=20
> I think that's unlikely.  In replace, one drive responds for sectors
> below the progress mark, and the other drive responds for sectors abo=
ve it.

>> I can say this state seems to survive reboots.
>=20
> That suggests you give a vanilla (or near-vanilla) kernel a try with =
one
> of the various liveCDs that have them.  I personally find the one fro=
m
> sysrescuecd.org to be most convenient, but I'm a gentoo guy :-)

I used to run SLS back in the day before everyone got all crazy with
the distributions.

> Otherwise, consider adding a third drive to see if it will rebuild an=
d
> break the deadlock.

I=E2=80=99m currently out of physical slots for drives so this poses a =
challenge,
plus the machine is 250 mi away, but I do have console/IPMI.

> I should have to say, but I hope you have a backup :-)

There is a qcow file on the mirrored SSDs which seems to be ok as I was=
=20
able to SCP it off to another host once I found space to toss a 800gb
file.  I may even be mailing you from said qcow.

it seems others were able to perhaps recover from not quite exact situa=
tions
by stopping and forcing a reassemble, but as copying 800gb would take a=
 few
hours again, I=E2=80=99m nervous to perform such an action.  e.g.:
http://ubuntuforums.org/showthread.php?t=3D1707416

I guess this means when I visit the machine next week I should take the=
=20
large external drive array and sas controller card I have here at home
as a checked bag.

	- Jared--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
