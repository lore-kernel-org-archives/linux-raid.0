From: CoolCold <coolthecold@gmail.com>
Subject: Re: possible bug - bitmap dirty pages status
Date: Wed, 16 Nov 2011 13:36:02 +0400
Message-ID: <CAGqmV7qSs8gvHe2Z4b7zc85zzd++45-XNSx5NudwC6RMVOeh=A@mail.gmail.com>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
	<CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
	<CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
	<4E5E2F7D.1010306@anonymous.org.uk>
	<CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com>
	<CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com>
	<CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com>
	<20110901154022.45f54657@notabene.brown>
	<4EC1A037.4080406@fastmail.fm>
	<CAGqmV7qpQBHLcJ9J9cP1zDw6kp6aLcaCMneFYEgcPOu7doXSMA@mail.gmail.com>
	<20111116140707.162d07e2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111116140707.162d07e2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linbloke <linbloke@fastmail.fm>, Paul Clements <paul.clements@us.sios.com>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 16, 2011 at 7:07 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 16 Nov 2011 03:13:51 +0400 CoolCold <coolthecold@gmail.com> w=
rote:
>
>> As I promised I was collecting data, but forgot to return to that
>> problem, bumping thread returned me to that state ;)
>> So, data was collected for almost the month - from 31 August to 26 S=
eptember:
>> root@gamma2:/root# grep -A 1 dirty component_examine.txt |head
>> =A0 =A0 =A0 =A0 =A0 Bitmap : 44054 bits (chunks), 190 dirty (0.4%)
>> Wed Aug 31 17:32:16 MSD 2011
>>
>> root@gamma2:/root# grep -A 1 dirty component_examine.txt |tail -n 2
>> =A0 =A0 =A0 =A0 =A0 Bitmap : 44054 bits (chunks), 1 dirty (0.0%)
>> Mon Sep 26 00:28:33 MSD 2011
>>
>> As i can understand from that dump, it was bitmap examination (-X ke=
y)
>> of component /dev/sdc3 of raid /dev/md3.
>> Decreasing happend, though after some increase on 23 of September, a=
nd
>> first decrease to 0 happened on 24 of September (line number 436418)=
=2E
>>
>> So almost for month, dirty count was no decreasing!
>> I'm attaching that log, may be it will help somehow.
>
> Thanks a lot.
> Any idea what happened at on Fri Sep 23??
> Between 6:23am and midnight the number of dirty bits dropped from 180=
 to 2.
Have no idea, sorry. 6.25 am scheduled in cron for logrotation, but
6.23 has nothing specific

But changes (dirty increase) begun to happen on 2:30 AM , which
corresponds with some cron-running script which does data import &
database update  - database lives on that LVMed md array.

>
> This does seem to suggest that md is just losing track of some of the=
 pages
> of bits and once they are modified again md remembers to flush them a=
nd write
> them out - which is a fairly safe way to fail.
>
> The one issue I have found is that set_page_attr uses a non-atomic __=
set_bit
> because it should always be called under a spinlock. =A0But bitmap_wr=
ite_all()
> - which is called when a spare is added - calls it without the spinlo=
ck so
> that could corrupt some of the bits.
>
> Thanks,
> NeilBrown
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
