From: Phil Turmel <philip@turmel.org>
Subject: Re: 3TB drives failure rate (summary)
Date: Wed, 31 Oct 2012 08:35:11 -0400
Message-ID: <50911AFF.9020707@turmel.org>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net> <508DC6E9.8070001@shiftmail.org> <508DC922.7040400@meetinghouse.net> <20121029102919.1134a797@natsu> <508E3626.8080404@hesbynett.no> <508E7E68.1030202@turmel.org> <1494377384.20121031005457@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494377384.20121031005457@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/30/2012 07:54 PM, Rainer F=C3=BCgenstein wrote:
>=20
> tnx for your input; apart from the detailed discussion the topic may
> be summarised like this:
>=20
> - better buy WD red drives next time (will do!)
>=20
> - other manufacturers drives fail too, not only a WD issue
>=20
> - drives from one (bad) batch are more likely to fail
>=20
> current status:
>=20
> the raid5 assembled of just 3 WD 3TB green drives works fine so far,
> even under load. no bad sectors so far (knocking on wood). will exten=
d
> it to 4 drives as soon as the replacement drive arrives.
>=20
> the drives are installed in the same chassis and bays as all the
> previous drives, therefore it is unlikely that the failures were
> caused by overheating/vibrations etc.
>=20
> never had any (serious) problems with 750GB and 1.5TB WD green drives
> before.

I strongly encourage you to run "smartctl -l scterc /dev/sdX" for each
of your drives.  For any drive that warns that it doesn't support SCT
ERC, set the controller device timeout to 180 like so:

echo 180 >/sys/block/sdX/device/timeout

If the report says read or write ERC is disabled, run "smartctl -l
scterc,70,70 /dev/sdX" to set it to 7.0 seconds.

You then set up a boot-time script to do these adjustments at every res=
tart.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
