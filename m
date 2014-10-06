From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot replacing device in RAID 6
Date: Mon, 6 Oct 2014 15:30:44 +0200
Message-ID: <CAAOsTSk-_mMcYziYxTuwggBBhDt1dsJbDE5Ph_vaZo2_MBqwtQ@mail.gmail.com>
References: <CAAOsTSmn3MDn-a6usUTpmBObwYngvFNNRUXXF6zhmDKyUTHU_w@mail.gmail.com>
	<gaf8gbxi4k.ln2@goaway.wombat.san-francisco.ca.us>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gaf8gbxi4k.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for assistance, it seems that everything worked fine. But I
need yet to check the array to be sure.

2014-10-05 20:30 GMT+02:00 Keith Keller <kkeller@wombat.san-francisco.c=
a.us>:
> On 2014-10-05, Patrik Horn=EDk <patrik@dsl.sk> wrote:
>>
>> - We discussed couple of years ago hot replacing the drive. I see it
>> is now supported in mdadm. Is it rock stable and can be used on
>> production data?
>
> I have used replace a handful of times with great success and no
> problems.  I have not had to shut down the array during the rebuild
> operation, however.  I suspect (but have no direct evidence) that a
> clean shutdown should be fine.  I used kernel 3.9 from ELRepo for
> the replace.
>
> --keith
>
>
> --
> kkeller@wombat.san-francisco.ca.us
>
>
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
