From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Data offset
Date: Fri, 16 May 2014 02:41:15 +0200
Message-ID: <CAAOsTSnzZaS__PWmvgEmdji8S_YGyvRRt_ebw+FZvir3Qg_55Q@mail.gmail.com>
References: <CAAOsTSmQUzup9Oy1EZstEi-bqZPgYhuhT6upQsoEc7TXq7n3kg@mail.gmail.com>
	<20140516080746.74daa4ca@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140516080746.74daa4ca@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2014-05-16 0:07 GMT+02:00 NeilBrown <neilb@suse.de>:
> On Thu, 15 May 2014 16:11:46 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> Hello,
>>
>> I have couple of questions regarding data offset:
>>
>> - Current mdadm sets 128 MiB offset apparently for reshaping backup
>> file. Is it really used by reshape? From which kernel / mdadm versio=
n?
>
> Yes.  Linux 3.5 or there abouts.  mdadm 3.3
>>
>> - Is there any other good reason for such big offset?
>
> No.  But when you typically have a terabyte of more per disc, 128MB i=
sn't
> very much.
>
>>
>> - Is there a support for specifying data offset when creating array?
>> In which version of mdadm? What are recommended lower values?
>
> Yes. mdadm-3.3.  Recommended value is the default.  Lowest usable val=
ue is
> the lowest value it will let you use.
>

Does lowest value depend on something? Or is it fixed and what is it?
Are there any other considerations for offset size like to be able add
more devices in array, etc? (I dont know how big is this minimal value
and how big is record per device for example...)

> Why does a 128MB offset bother you?

It does not by itself. But I am doing some reorganization, including
new layer and need to fit existing fs back on same drives. So I need
to save space in RAID level to be able to fit new layer.

Patrik

>
> NeilBrown
>
>>
>> Thanks.
>>
>> Patrik
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
