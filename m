From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 9 Jun 2015 20:06:43 +0100
Message-ID: <CAOS+5GG+qUz4No+Cur5_EEdv8ssAXzy41bFw524uEN9zpt-qKQ@mail.gmail.com>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
	<55767860.5000803@gmail.com>
	<55773493.3050605@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55773493.3050605@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you can try to pick up a cheap IBM M1015 Raid controller that you
can configure as JBOD (look to pay no more then =C2=A350 or $75).

=46lash it to the standard LSI firmware (google M1015 LSI
firmware...there's plenty of forum pages on this).

Add your new drives to this controller, build new raid on this new
controller......copy dataset from old array.

I personally would NEVER suggest doing a migrate of drives or data
sizes on an active live dataset...if anything goes wrong you could
easily kill your data and have no backup.



On 9 June 2015 at 19:46, Wols Lists <antlists@youngman.org.uk> wrote:
> On 09/06/15 06:23, Can Jeuleers wrote:
>> On 08/06/15 21:28, Pierre Wieser wrote:
>>> Hi all,
>>>
>>> I currently have an almost full RAID 5 built with 4 x 2 TB disks.
>>> I wonder if it would be possible to migrate it to a bigger RAID 5
>>> with 3 x 6TB new disks.
>>
>> I'd recommend against it:
>>
>> https://en.wikipedia.org/wiki/RAID#Unrecoverable_read_errors_during_=
rebuild
>>
>> Jan
>>
> Please expand! Having read the article, it doesn't seem to say anythi=
ng
> more than what is repeated time and time on this list - MAKE SURE YOU=
R
> DRIVES ARE DECENT RAID DRIVES.
>
> If you have ERC, then the odd "soft" read error doesn't matter. If yo=
u
> don't have ERC, then your data is at risk when you replace a drive, a=
nd
> it doesn't matter how big your drives are, it's the array size that m=
atters.
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
