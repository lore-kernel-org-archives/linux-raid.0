From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: mdadm/Monitor.c - never removes MD devices from statelist
Date: Mon, 12 Sep 2011 11:32:23 +0300
Message-ID: <CAGRgLy4=dMRmqZW4_+Wv+0QZzanH_ZCX88xxL5QD2OK03GmYww@mail.gmail.com>
References: <CAGRgLy4=mq_py=Qr+Mk8MOvXY1fbwgeEmEr1kAcmiwHQfCZweg@mail.gmail.com>
	<20110912053646.5eb0b55d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110912053646.5eb0b55d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,
yes, I will try to produce a patch (although I am using git, I have
never done patches yet).

But I don't understand why do you require 'err' to be set. I would say
that when there is a "DeviceDisappeared" event plus --scan is set,
then you should remove. (And also perhaps if this array does not
appear in the device list provided by the user).

Alex.


On Mon, Sep 12, 2011 at 6:36 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 11 Sep 2011 21:32:12 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Hi everybody,
>> looking at the code of Monitor.c and doing some tests with it, I see
>> that it is capable of detecting new arrays, when they appear in
>> /proc/mdstat (if --scan is given). However, once array is added to
>> 'statelist', it is never removed from there. Is this intentional?
>> Perhaps only if --scan is given, and device disappears from
>> /proc/mdstat, then it should be removed from monitoring, otherwise i=
t
>> could stick there forever, even though the array has been gone long
>> time ago. And if it appears again, it will be picked up anyways.
>>
>
> You are right - arrays are never removed.
>
> Is that a problem? =A0Probably not, though I guess you could probably=
 create
> a scenario where there were lots of inactive devices cluttering memor=
y.
>
> Is it worth fixing? =A0I don't know - it depends on how intrusive the=
 patch is.
> We would only want to remove arrays with ->err set if 'scan' was set,=
 but
> when it is, it possible makes sense.
>
> Want to try creating a patch?
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
