From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Mon, 14 May 2012 02:52:01 +0200
Message-ID: <CAAOsTSm3aQFydumTfAVr2DQZoxcENvzpfyS8zbNdxUcnFsDkpQ@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
	<CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
	<CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
	<20120513091901.5265507f@notabene.brown>
	<CAAOsTSk7dDcMGGJgAJ6GSDU2WpsJPTS3Vb80WKy6CObwtemfgQ@mail.gmail.com>
	<CAAOsTSkVwCkY3YAKPTDFo2uZoG6S6Et0DYtDzk+QNfy+N3kMag@mail.gmail.com>
	<20120514081523.2f38dbb8@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120514081523.2f38dbb8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well,

I used raid=3Dnoautodetect and the other arrays did start automatically=
=2E
I am not sure who started them, maybe  initscripts... But the one
which is reshaping thankfully did not start.

Unfortunately  the speed is not much better. The top speed is up by
cca third to maybe 2.3 MB/s, which seems pretty small and I am unable
to quickly pinpoint the exact reason.Do you have idea what can it be
and how to improve speed?

In addition the performance problem with bad drive periodically kicks
in sooner and thus the average speed is almost the same, around 0.8 to
0.9 MB/s. I am thinking about failing the problematic drive. Except
that I will end up without redundancy for yet not reshaped part,
should the failing work as expected even in the situation array is
now? (raid6 with 8 drives, 7 active devices in not yet reshaped part,
couple of times stopped and start with backup-file.)

Thanks.

Patrik

On Mon, May 14, 2012 at 12:15 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 13 May 2012 23:41:35 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> Hi Neil,
>>
>> I decided to move backup file on other device. I stopped the array,
>> mdadm stopped it but wrote "mdadm: failed to unfreeze array". What
>> does it exactly mean? I dont want to proceed until I am sure it does
>> not signalize error.
>
> That would appear to be a minor bug in mdadm - I've made a note.
>
> When reshaping an array like this, the 'mdadm' which started the resh=
ape
> forks and continues in the background managing the the =A0backup file=
=2E
> When it exits, having completed, it makes sure that the array is 'unf=
rozen'
> just to be safe.
> However if it exits because =A0the array was stopped, there is no arr=
ay to
> unfreeze an it gets a little confused.
> So it is a bug but it does not affect the data on the devices or indi=
cate
> that anything serious went wrong when stopping the array.
>
>>
>> I quickly checked sources and it seems to be related to some sysfs
>> resources, but I am not sure. But the array disappeared from
>> /sys/block/.
>
> Exactly. =A0And as the array disappeared, it really has stopped.
>
>
>>
>> Thanks.
>>
>> Patrik
>>
>> On Sun, May 13, 2012 at 9:43 AM, Patrik Horn=EDk <patrik@dsl.sk> wro=
te:
>> > Hi Neil,
>> >
>> > On Sun, May 13, 2012 at 1:19 AM, NeilBrown <neilb@suse.de> wrote:
>> >> On Sat, 12 May 2012 17:56:04 +0200 Patrik Horn=EDk <patrik@dsl.sk=
> wrote:
>> >>
>> >>> Neil,
>> >>
>> >> Hi Patrik,
>> >> =A0sorry about the "--layout=3Dpreserve" confusion. =A0I was a bi=
t hasty.
>> >> =A0-layout=3Dleft-symmetric-6" would probably have done what was =
wanted, but it
>> >> =A0is a bit later for that :-(
>> >
>> > --layout=3Dpreserve is mentioned also in the md or mdadm
>> > documentation... So is it not the right one?
>
> It should be ... I think. =A0But it definitely seems not to work. =A0=
I only have
> a vague memory of how it was meant to work so I'll have to review the=
 code
> and add some proper self-tests.
>
>> >
>> >>>
>> >>> so I further analyzed the behaviour and I found following:
>> >>>
>> >>> - The bottleneck cca 1.7 MB/s is probably caused by backup file =
on one
>> >>> of the drives, that drive is utilized almost 80% according to io=
stat
>> >>> -x and its avg queue length is almost 4 while having await under=
 50
>> >>> ms.
>> >>>
>> >>> - The variable speed and low speeds down to 100 KB are caused by
>> >>> problems on drive I suspected as problematic. Its service time i=
s
>> >>> sometimes going above 1 sec.. Total avg speed is about 0.8 MB/s.=
 (I
>> >>> tested the read speed on it by running check of array and it wor=
ked
>> >>> with 30 MB/s. And because preserve should only read from it I di=
d not
>> >>> specifically test its write speed )
>> >>>
>> >>> So my questions are:
>> >>>
>> >>> - Is there a way I can move backup_file to other drive 100% safe=
ly? To
>> >>> add another non-network drive I need to restart the server. I ca=
n boot
>> >>> it then to some live distribution for example to 100% prevent
>> >>> automatic assembly. I think speed should be couple of times high=
er.
>> >>
>> >> Yes.
>> >> If you stop the array, then copy the backup file, then re-assembl=
e the
>> >> array giving it the backup file in the new location, all should b=
e well.
>> >> A reboot while the array is stopped is not a problem.
>> >
>> > Should or will? :) I have 0.90, now 0.91, metadata, is everything
>> > needed stored there? Should mdadm 3.2.2-1~bpo60+2 from
>> > squeeze-backports work well? Or should I compile mdadm 3.2.4?
>
> "Will" requires clairvoyance :-)
> 0.91 is the same as 0.90, except that the array is in the middle of a=
 reshape.
> This make sure that old kernels which don't know about reshape never =
try to
> start the array.
> Yes - everything you need is stored in the 0.91 metadata and the back=
up file.
> After a clean shutdown, you could manage without the backup file if y=
ou had
> to, but as you have it, that isn't an issue.
>
>> >
>> > In case there is some risk involved I will need to choose between
>> > waiting and risking power outage happening sometimes in the follow=
ing
>> > week (we have something like storm season here) and risking this..=
=2E
>
> There is always risk.
> I think you made a wise choice in choosing the move the backup file.
>
>> >
>> > Do you recommend some live linux distro installable on USB which i=
s
>> > good for this? (One that has newest versions and dont try assemble
>> > arrays.)
>
> No. =A0Best to use whatever you are familiar with.
>
>
>> >
>> > Or will automatic assemble fail and it will cause no problem at al=
l
>> > for sure? (According to md or mdadm doc this should be the case.) =
In
>> > that case can I use distribution on the server, Debian stable plus
>> > some packages from squeeze, for that? Possibly with added
>> > raid=3Dnoautodetect? I have LVM on top of raid arrays and I dont w=
ant to
>> > cause mess. OS is not on LVM or raid.
>> >
>
> raid=3Dnoautodetect is certainly a good idea. I'm not sure if the in-=
kernel
> autodetect will try to start a reshaping raid - I hope not.
>
>> >>>
>> >>> - Is it safe to fail and remove problematic drive? The array wil=
l be
>> >>> down to 6 from 8 drives in part where it is not reshaped. It sho=
uld
>> >>> double the speed.
>> >>
>> >> As safe as it ever is to fail a device in a non-degraded array.
>> >> i.e. it would not cause a problem directly but of course if you g=
et an error
>> >> on another device, that would be awkward.
>> >
>> > I actually "check"-ed this raid array couple of times few days ago=
 and
>> > data on other drives were OK. Problematic drive reported couple of
>> > reading errors, always corrected with data from other drives and b=
y
>> > rewriting.
>
> That is good!
>
>> >
>> > About that, shoud this reshaping work OK if it encounter possible
>> > reading errors on problematic drive? Will it use data from other
>> > drives to correct that also in this reshaping mode?
>
> As long as there are enough working drives to be able to read and wri=
te the
> data, the reshape will continue.
>
> NeilBrown
>
>
>> >
>> > Thanks.
>> >
>> > Patrik
>> >
>> >>>
>> >>> - Why mdadm did ignore layout=3Dpreserve? I have other arrays in=
 that
>> >>> server in which I need replace the drive.
>> >>
>> >> I'm not 100% sure - what version of mdadm are you using?
>> >> If it is 3.2.4, then maybe commit 0073a6e189c41c broke something.
>> >> I'll add test for this to the test suit to make sure it doesn't b=
reak again.
>> >> But you are using 3.2.2 .... Not sure. I'd have to look more clos=
ely.
>> >>
>> >> Using --layout=3Dleft-symmetric-6 should work, though testing on =
some
>> >> /dev/loop devices first is always a good idea.
>> >>
>> >> NeilBrown
>> >>
>> >>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
