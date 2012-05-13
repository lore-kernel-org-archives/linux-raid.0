From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Sun, 13 May 2012 09:43:58 +0200
Message-ID: <CAAOsTSk7dDcMGGJgAJ6GSDU2WpsJPTS3Vb80WKy6CObwtemfgQ@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
	<CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
	<CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
	<20120513091901.5265507f@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120513091901.5265507f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Sun, May 13, 2012 at 1:19 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 12 May 2012 17:56:04 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> Neil,
>
> Hi Patrik,
> =A0sorry about the "--layout=3Dpreserve" confusion. =A0I was a bit ha=
sty.
> =A0-layout=3Dleft-symmetric-6" would probably have done what was want=
ed, but it
> =A0is a bit later for that :-(

--layout=3Dpreserve is mentioned also in the md or mdadm
documentation... So is it not the right one?

>>
>> so I further analyzed the behaviour and I found following:
>>
>> - The bottleneck cca 1.7 MB/s is probably caused by backup file on o=
ne
>> of the drives, that drive is utilized almost 80% according to iostat
>> -x and its avg queue length is almost 4 while having await under 50
>> ms.
>>
>> - The variable speed and low speeds down to 100 KB are caused by
>> problems on drive I suspected as problematic. Its service time is
>> sometimes going above 1 sec.. Total avg speed is about 0.8 MB/s. (I
>> tested the read speed on it by running check of array and it worked
>> with 30 MB/s. And because preserve should only read from it I did no=
t
>> specifically test its write speed )
>>
>> So my questions are:
>>
>> - Is there a way I can move backup_file to other drive 100% safely? =
To
>> add another non-network drive I need to restart the server. I can bo=
ot
>> it then to some live distribution for example to 100% prevent
>> automatic assembly. I think speed should be couple of times higher.
>
> Yes.
> If you stop the array, then copy the backup file, then re-assemble th=
e
> array giving it the backup file in the new location, all should be we=
ll.
> A reboot while the array is stopped is not a problem.

Should or will? :) I have 0.90, now 0.91, metadata, is everything
needed stored there? Should mdadm 3.2.2-1~bpo60+2 from
squeeze-backports work well? Or should I compile mdadm 3.2.4?

In case there is some risk involved I will need to choose between
waiting and risking power outage happening sometimes in the following
week (we have something like storm season here) and risking this...

Do you recommend some live linux distro installable on USB which is
good for this? (One that has newest versions and dont try assemble
arrays.)

Or will automatic assemble fail and it will cause no problem at all
for sure? (According to md or mdadm doc this should be the case.) In
that case can I use distribution on the server, Debian stable plus
some packages from squeeze, for that? Possibly with added
raid=3Dnoautodetect? I have LVM on top of raid arrays and I dont want t=
o
cause mess. OS is not on LVM or raid.

>>
>> - Is it safe to fail and remove problematic drive? The array will be
>> down to 6 from 8 drives in part where it is not reshaped. It should
>> double the speed.
>
> As safe as it ever is to fail a device in a non-degraded array.
> i.e. it would not cause a problem directly but of course if you get a=
n error
> on another device, that would be awkward.

I actually "check"-ed this raid array couple of times few days ago and
data on other drives were OK. Problematic drive reported couple of
reading errors, always corrected with data from other drives and by
rewriting.

About that, shoud this reshaping work OK if it encounter possible
reading errors on problematic drive? Will it use data from other
drives to correct that also in this reshaping mode?

Thanks.

Patrik

>>
>> - Why mdadm did ignore layout=3Dpreserve? I have other arrays in tha=
t
>> server in which I need replace the drive.
>
> I'm not 100% sure - what version of mdadm are you using?
> If it is 3.2.4, then maybe commit 0073a6e189c41c broke something.
> I'll add test for this to the test suit to make sure it doesn't break=
 again.
> But you are using 3.2.2 .... Not sure. I'd have to look more closely.
>
> Using --layout=3Dleft-symmetric-6 should work, though testing on some
> /dev/loop devices first is always a good idea.
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
