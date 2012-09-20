From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Thu, 20 Sep 2012 11:34:12 -0600
Message-ID: <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <7577D4C6-344F-4AE6-BB6A-3B4F29D4CAA0@colorremedies.com> <2627519.Y2VdWh5VBI@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2627519.Y2VdWh5VBI@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 20, 2012, at 5:05 AM, G=FCnther J. Niederwimmer wrote:
>=20
> this is "normal" I install "windows 7" first ;). but the problem with=
 the=20
> wrong GPT Table Message I have also on a Raid10 with "Intel Matrix St=
orage"=20
> and dmraid installation.
>=20
>=20

OK you didn't answer my question about what mdadm metadata version your=
 md RAID is using. If it's 1.0 instead of 1.2 that could be the culprit=
=2E

> The Question is, work parted correct with Raid GPT Table?

Could be a bug in parted 2.3, which is old. Try using parted 3.0.

Another question is, do you really think it's a good idea to be mixing =
different RAID implementations on the same physical devices, which also=
 appear to contain boot volumes?

I think one of your RAID implementations is stepping on the GPT seconda=
ry header. I've seen this before in a BIOS "fakeraid" implementation. S=
o I would look at all of your RAID implementations, make sure they're u=
sing the latest versions.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
