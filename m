From: CoolCold <coolthecold@gmail.com>
Subject: Re: [PATCH][Trivial] mdadm man page: fix typo
Date: Thu, 12 Apr 2012 07:00:53 +0400
Message-ID: <CAGqmV7qbGwZi5JAGmk0vxU5qJE2q9sYrrvjp97rbn8crV=m2gg@mail.gmail.com>
References: <CAGqmV7ovw0fW2HE0s69Ci7Y15YWGpnvESfW=rt=rEbp0kWPp_w@mail.gmail.com>
	<20120412124427.7ecb8ee2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120412124427.7ecb8ee2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 12, 2012 at 6:44 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 12 Apr 2012 06:11:19 +0400 CoolCold <coolthecold@gmail.com> w=
rote:
>
>> manpage for mdadm(8) contains typo - missing "d" at the end of "desc=
ribe" word.
>>
>> Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
>> ---
>> =A0mdadm.8.in | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mdadm.8.in b/mdadm.8.in
>> index 4f06a88..bddecd9 100644
>> --- a/mdadm.8.in
>> +++ b/mdadm.8.in
>> @@ -1166,7 +1166,7 @@ will report failure if these specifiers didn't
>> find any match.
>> =A0.BR \-a ", " \-\-add
>> =A0hot-add listed devices.
>> =A0If a device appears to have recently been part of the array
>> -(possibly it failed or was removed) the device is re\-added as desc=
ribe
>> +(possibly it failed or was removed) the device is re\-added as desc=
ribed
>> =A0in the next point.
>> =A0If that fails or the device was never part of the array, the devi=
ce is
>> =A0added as a hot-spare.
>> --
>> 1.7.2.5
>> 1.7.2.5
>>
>>
>
> Thanks.
> Patch was slightly malformed ("find any match" should have been on en=
d of
> previous line) but I fixed that and applied.
Huh, I guess I should avoid gmail's web interface for patch sending
tasks and be careful in general.

Thanks for you fixes!

>
> NeilBrown



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
