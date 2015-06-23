From: Phil Turmel <philip@turmel.org>
Subject: Re: (R) in mdstat output, clean && degraded
Date: Tue, 23 Jun 2015 16:12:58 -0400
Message-ID: <5589BDCA.5050801@turmel.org>
References: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jared Mauch <jared@puck.nether.net>, linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Jared,

On 06/23/2015 02:56 PM, Jared Mauch wrote:
> I=E2=80=99ve been searching high and low the past few days and have b=
een unable to diagnose what this (R) is in my raid1 mdstat output indic=
ates.

Replacement device.

> It seems something is =E2=80=98stuck=E2=80=99 somehow as I=E2=80=99m =
not sure how the array is both clean and degraded at the same time.

Role '0', currently sdd1, is being replaced with sdg1.  Both appear to
be working as expected and are therefore individually 'clean'.  Role '1=
'
is missing, and therefore the array as a whole is degraded.

Looks to me like you lost a device and should have used --add to put a
new device into service, but you used --replace instead.  --replace is
for use when a functioning device shows signs of failing and is to be
replaced 'on-the-fly'.

[trim /]

>    Device Role : Replacement device 0
>    Array State : R. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

However, the array doesn't seem to be making progress on the replacemen=
t
(didn't even start ?), so this pathological situation might have
triggered a bug in the resync code.

Neil?

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
