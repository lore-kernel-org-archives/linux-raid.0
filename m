From: CoolCold <coolthecold@gmail.com>
Subject: Re: raid(1) and block caching
Date: Mon, 31 Oct 2011 22:53:04 +0400
Message-ID: <CAGqmV7qfQJsT7YHSVfWR-vQNC7mpg-iVUNWi+i09L2kiu4QcLw@mail.gmail.com>
References: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com>
	<20111029172641.57f92fc3@notabene.brown>
	<4EAD44DF.6050000@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAD44DF.6050000@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Oct 30, 2011 at 4:36 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 29/10/2011 07:26, NeilBrown wrote:
>>
>> On Sat, 29 Oct 2011 08:49:09 +0400 CoolCold<coolthecold@gmail.com> =A0=
wrote:
>
> [...]
>>>
>>> As there are some pros and cons on both sides (at least theoretical=
ly)
>>> =A0I have dumb question - let's say our array md1 consists on 3 dri=
ves -
>>> /dev/sd{a,b,c} - and when data read from md1 occurs, which block is
>>> cached in VFS (or may be other cache in system, it would be nice to
>>> know which part of system is doing caching) =A0- the block from md1
>>> itself or from certain drive? If it is drive-based block cache, it'=
s
>>> gonna be potentially memory wasting to keep 3 similar data copies, =
so
>>> I assume md does data reads with something like O_DIRECT flag, but =
as
>>> I 1) don't know C 2) don't know kernel, I'm asking this on the list=
 to
>>> make this clean for myself.
>>
>> The kernel caches pages of files, not pages of devices.
>> It doesn't matter where the page of data came from - it is the page =
of a
>> file
>> that is cached.
>
> I suppose if the user was silly enough to mount the same filesystem f=
rom
> both md1 and sd{a,b,c} simultaneously then there could be duplication=
 of
> caching, but as I say I think that'd be a silly configuration :-)
Hehe, this is not the situation I'm looking through, there is no
vaccine against shooting in own leg ;)

>
> Cheers,
>
> John.
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
