From: Fabien Bourigault <dradge@gmail.com>
Subject: Re: Check / Automatic repair
Date: Mon, 21 May 2012 13:25:42 +0200
Message-ID: <CAFYuN7pu=gCR_cV45t2NRnw5TcUbfOouq=Ug5wP70+X8hLqYQw@mail.gmail.com>
References: <CAFYuN7qTy5Apj265N6PiyvbU5QmS7=ry+ofi=vHjzDfsf7uh5g@mail.gmail.com>
	<20120521201538.1fbac51b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120521201538.1fbac51b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So, what really happens if I do :

echo "check" > /sys/block/md0/md/sync_action

or :

echo "repair" > /sys/block/md0/md/sync_action

?

2012/5/21 NeilBrown <neilb@suse.de>:
> On Mon, 21 May 2012 12:09:47 +0200 Fabien Bourigault <dradge@gmail.co=
m> wrote:
>
>> Hi,
>>
>> I was reading the kernel md.txt documentation and found that couple =
of
>> sentences about sync_action :
>>
>> 496 =C2=A0 =C2=A0 =C2=A0 =C2=A0check =C2=A0 =C2=A0 =C2=A0 =C2=A0 - A=
 full check of redundancy was requested and is
>> 497 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0happening. =C2=A0This reads all block and checks
>> 498 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0them. A repair may also happen for some raid
>> 499 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0levels.
>>
>>
>> What levels/configurations are affected by the "A repair may also
>> happen for some raid levels." sentence ?
>
> Someone really should find time to fix up that file....
>
> I don't remember the details of what it meant at the time, but with c=
urrent
> code 'check' means a check is happening for all raid levels, and 'rep=
air'
> means a repair is happening.
>
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
