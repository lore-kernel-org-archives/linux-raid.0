From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Wed, 17 Oct 2012 09:03:11 +0100
Message-ID: <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
	<C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17 October 2012 04:06, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 16, 2012, at 4:57 PM, Mathias Bur=C3=A9n wrote:
>
>> I started a reshape from 64K chunk size to 512K
>
> I agree with Stan, not a good idea, and also a waste of time. Do you =
have check scrubs and extended offline smart tests scheduled for these =
drives periodically?
>

Weekly scrubs and weekly offline self-tests. SMART always looked good,
until 1 drive died completely, the other has 5 uncorrectable sectors.
LCC is under 250K. WD20EARS

There are basically no files under 8GB on the array so therefore I
thought the new chunk size made sense.

>>
>> I guess my question is if it's possible for me to remove the drive, =
or
>> would I mess the array up? I am not going to anything until the
>> reshape finishes though.
>
> I think you should put in a replacement drive for sda (#6) and get it=
 rebuilding, as sde seems rather tenuous, before you decide to remove s=
de.
>
> You should find out why it's slow 'smartctl -A /dev/sde' might reveal=
 this now, which you can issue even while the reshape is occurring - th=
e command just polls for existing smart attribute values for the drive.=
 If it's the same model disk, connected the same way, as all the other =
drives, I'd get rid of it.

It's slow because it's broken (see above).

Any idea why it says rebuilding, when it's not? Is it going to attempt
a rebuild after the reshape?

>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
