From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Wed, 16 Feb 2011 18:19:41 -0600
Message-ID: <4D5C699D.5010509@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5A7198.7060607@hardwarefreak.com> <ijdvmn$4ff$1@dough.gmane.org> <4D5C5EAA.3020208@hardwarefreak.com> <20110217000058.GA16130@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217000058.GA16130@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 2/16/2011 6:00 PM:
> On Wed, Feb 16, 2011 at 05:32:58PM -0600, Stan Hoeppner wrote:
>> David Brown put forth on 2/15/2011 7:39 AM:
>>
>> RAID level space/cost efficiency from a TCO standpoint is largely ir=
relevant
>> today due to the low price of mech drives.  Using the SATABeast as a=
n example,
>> the cost per TB of a 20TB RAID 10 is roughly $1600/TB and a 20TB RAI=
D 6 is about
>> $1200/TB.  Given all the advantages of RAID 10 over RAID 6 the 33% p=
remium is
>> more than worth it.
>=20
> I assume that you with 20 TB mean the payload space in both places, t=
hat
> is for the Linux MD RAID10 you actually have 40 TB of raw disk space.
> With the Linux MD raid10 solution you furthermore can enjoy an almost
> double up of the IO reading speed, involving 20 * 2 TB spindles compa=
red
> to 12 * 2 TB spindles.

Enterprise solutions don't use Linux mdraid.  The RAID function is buil=
t into
the SAN controller.  My TCO figures were based on a single controller S=
ATABeast,
42x1TB drives in the RAID 10, and 24x1TB drives in the RAID 6, each
configuration including two spares.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
