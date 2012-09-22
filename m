From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: GPT Table broken on a Raid1
Date: Sat, 22 Sep 2012 16:31:46 +0100
Message-ID: <505DD9E2.7090908@anonymous.org.uk>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?windows-1252?Q?=22G=FCnther_J=2E_Niederwimmer=22?= <gjn@gjn.priv.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Chris Murphy <lists@colorremedies.com>
List-Id: linux-raid.ids

On 21/09/2012 23:43, Chris Murphy wrote:
>
> On Sep 21, 2012, at 1:35 PM, Chris Murphy wrote:
>
>> If you're making the RAID with that, it defaults to metadata version=
 1.2. But to be sure
>> mdadm -E /dev/mdX
>
> Scratch that. I was confused. Try these instead:
>
> mdadm -=96detail-platform
> mdadm =96D /dev/md/imsm
> mdadm =96E /dev/sdX

I don't think there's anything wrong here.

The kernel sees the whole discs, sda and sdb, and complains that the GP=
T=20
partition table looks wrong becase the second copy isn't at the end of=20
the discs. That's correct, at the end of the raw discs is the IMSM=20
metadata. Once you've assembled the IMSM array with mdadm, the partitio=
n=20
table inside /dev/md/Volume0 is correct.

You'd see the same thing with a native md device with metadata 0.90 or=20
1.0 made from whole discs and with a GPT partition table inside.

Don't try to change the partition tables on /dev/sda and sdb or you wil=
l=20
damage the IMSM metadata.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
