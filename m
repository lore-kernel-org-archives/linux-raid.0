From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Mixing WD red with older seagates
Date: Mon, 9 Sep 2013 15:56:26 +0100
Message-ID: <CADNH=7F0URr9w-f0whhyDS5drKkxo87bMyFrp46cAfBVXZ98Pg@mail.gmail.com>
References: <522D4369.80404@vorgon.com>
	<522D457D.1000900@smartguide.com.au>
	<BLU0-SMTP280B8900E5E83B76CADDD46983F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP280B8900E5E83B76CADDD46983F0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Wilson <piercing_male@hotmail.com>
Cc: Tudor Holton <tudor@smartguide.com.au>, "Timothy D. Lenz" <tlenz@vorgon.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9 September 2013 15:38, Jonathan Wilson <piercing_male@hotmail.com> wrote:
> On Mon, 2013-09-09 at 13:50 +1000, Tudor Holton wrote:
>> Completely anecdotal evidence, but I was mixing WD Reds and Seagates in
>> a QNAP RAID 6 each 3TB for a total of 6TB, and the Seagates kept making
>> sounds like they were about to hurl.  Testing each drive individually
>> with badblocks and smart came up with all drives OK.  But it kept
>> chucking the WDs one by one.  Eventually I removed the Seagates and
>> replaced them with WDs and since then no drives have been thrown out.
>>
>> I can only theorise that there may be a timing issue between WD Reds and
>> Seagate.
>
> I wonder if the vibrations of the Seagates was causing the reds to be
> thrown?
>
> From what I've read (assuming I understand correctly) they are a low-ish
> vibration drive with some fancy head positioning for alignment... but
> should be limited to 5 at most, or at least are intended for upto 5
> drive systems, so I wonder if this means that more than 5 could suffer
> from vibrations throwing disks out?
>
> All that said, I wonder just how sensitive drives are nowadays? While I
> have heard of tales of old where someone sneezing in the computer room
> would cause large raid clusters to pop I don't know how true they are or
> how sensitive drives are to the accumulative vibrations of many disks or
> if its more of a case that as the number of disks increases then the
> statistical chance of a drive failing increases to the point that it is
> more likely to happen in coincidence with an external event, such as a
> sneeze.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


The sneeze story isn't true. Modern enterprise are sensitive, for
example some 24k RPM fans will cause drives to fail within time, but
12k fans won't (40mm).

However, if your room and your servers are normal, you've nothing to
worry about.

Mathias
