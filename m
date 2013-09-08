From: Phil Turmel <philip@turmel.org>
Subject: Re: raid6 array assembled from 11 drives and 2 spares - not enough
 to start the array
Date: Sun, 08 Sep 2013 09:30:33 -0400
Message-ID: <522C7BF9.2020107@turmel.org>
References: <CAH-e9vL7fUYSrd4J7+nej=xiqndgk3vim38Mu7+E-w37QX0Ebw@mail.gmail.com> <CAH-e9vJGPOWm2YqGk54CRtGVW1pYcxbU0xS9HaU74fR_q+Ecug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vJGPOWm2YqGk54CRtGVW1pYcxbU0xS9HaU74fR_q+Ecug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?R2Fyw7BhciBBcm5hcnNzb24=?= <gardar@giraffi.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/07/2013 07:49 PM, Gar=C3=B0ar Arnarsson wrote:
> I seem to have been able to resolve this.
>=20
> I tried force assembling the array with all the drives except for sda=
1
> (the problematic device before) that way the array got assembled with
> 12 drives and one spare, enough so I could recover the array.
>=20
> Still would want to know what might have caused these problems for th=
e
> first place, but I'm glad it seems to be working ok for now.

In my years of helping people on this list, the single most common caus=
e
of spurious dropouts is mismatched error recovery timeouts.  Caused by
use of desktop hard drives in raid arrays.  You should search the list
archives for various combinations of "scterc" "device/timeout" "tler"
and "ure".

Then report the following on the list (inline, not attached):

for x in /sys/block/*/device/timeout ; do echo $x $(< $x) ; done

smartctl -x /dev/sd[a-q]


HTH,

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
