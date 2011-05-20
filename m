From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 13:36:02 +0100
Message-ID: <BANLkTimvU-Roo=u0OmKjv=9YwtvJ-3cKQA@mail.gmail.com>
References: <4DD50C89.8060006@wildgooses.com>
	<20110520020853.GC4759@bitfolk.com>
	<4DD61948.8050302@wildgooses.com>
	<4DD65C18.5090804@gmail.com>
	<20110520183413.64fe3ccc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520183413.64fe3ccc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Joe Landman <joe.landman@gmail.com>, Ed W <lists@wildgooses.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20 May 2011 13:34, Roman Mamedov <rm@romanrm.ru> wrote:
> On Fri, 20 May 2011 08:18:32 -0400
> Joe Landman <joe.landman@gmail.com> wrote:
>
>> Second off, you can turn any of the expensive RAID cards into an 'JB=
OD'
>> by doing something like this:
>>
>> 1) have the unit configured in RAID mode
>>
>> 2) build virtual disks out of single drives, as RAID0.
>>
>> 3) iterate 2 until you exhaust your drives.
>>
>> 4) make sure you prevent these drives from messing with your boot dr=
ive
>> order ... some bioses "helpfully" reorganize new drives for you by
>> messing with this list.
>>
>> Once the drive is a 1 disk RAID0, you get the cache, and the BBU for=
 the
>> cache. =C2=A0Yeah, its a little weird. =C2=A0But it does work (we've=
 done this
>> with some LSI8888's).
>
> But can you then access SMART of the individual drives?
> Or will you see only some bogus block devices which do not accept SMA=
RT
> commands, do not return real drive identity, and present themselves a=
s RAID0
> #1, RAID0 #2 etc. instead?
>
> --
> With respect,
> Roman
>

Depends on the controller; e.g.

smartctl -A -d 3ware,$I /dev/twa0
smartctl -A -d megaraid,$I /dev/sda

(where $I is the port on the controller)

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
