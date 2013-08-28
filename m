From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: question about mdmon --takeover
Date: Wed, 28 Aug 2013 19:14:41 +0200
Message-ID: <CAC9WiBhab-Acx+U0NWAxki+M9sXccdEPBj=LyLPYQv3XQ_Nnxg@mail.gmail.com>
References: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
	<20130805165908.2d1e291b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130805165908.2d1e291b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,


Sorry for the late reply.

On Mon, Aug 5, 2013 at 8:59 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 31 Jul 2013 16:30:34 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
>
>> Hello list,
>>
>> I thought that using "--takeover" would hint mdmon to replace existing
>> mdmon process, and therefore the old one would exit somehow.
>>
>> However after several "mdmon --takeover" I can see this:
>>  $ ps aux | grep dmon
>> root       233  0.0  0.2  80388 10752 ?        SLsl 14:02   0:00 @dmon
>> --offroot md127
>> root      3326  0.0  0.2  14920 10820 ?        SLsl 15:16   0:00 mdmon
>> --takeover md127
>> root      3343  0.0  0.2  14920 10820 ?        SLsl 15:17   0:00 mdmon
>> --takeover md127
>>
>> Is this expected ?
>>
>> Thanks.
>
> Nope.  That's not expected.
>
> mdmon should send SIGTERM to the old mdmon and then wait for it to exit.
>
> If the new and old mdmon were compiled different and look for the pid file in
> different directories that might explain what you see.
>
> If you compile mdadm from source it will use /run/mdadm.  However if your
> distro doesn't have /run the the distro-provided mdadm will be compiled
> differently.
>

It doesn't to be the case.

Actually sending SIGTERM manually to mdmon has no effects.


# mdadm --version
mdadm - v3.2.6 - 25th October 2012

# ps aux | grep dmon
root       235  0.1  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
--offroot md127
root       339  0.0  1.0  15044 10944 ?        SLsl 19:08   0:00
/sbin/mdmon --takeover md127

# cat /run/mdadm/md127.pid
339

# kill -SIGTERM 339
# ps aux | grep dmon
root       235  0.0  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
--offroot md127
root       339  0.0  1.0  15044 10944 ?        SLsl 19:08   0:00
/sbin/mdmon --takeover md127

# ps aux | grep dmon
root       235  0.0  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
--offroot md127
root       339  0.0  1.0  15044 10944 ?        SLsl 19:08   0:00
/sbin/mdmon --takeover md127
root      2352  0.1  1.0  15076 10976 ?        SLsl 19:12   0:00 mdmon
--takeover /dev/md127

# cat /run/mdadm/md127.pid
2352

# pkill -SIGTERM mdmon
[root@localhost ~]# ps aux | grep dmon
root       235  0.0  1.0  80612 10976 ?        SLsl 19:08   0:00 @dmon
--offroot md127
root       339  0.0  1.0  80580 10944 ?        SLsl 19:08   0:00
/sbin/mdmon --takeover md127
root      2352  0.0  1.0  80612 10976 ?        SLsl 19:12   0:00 mdmon
--takeover /dev/md127

Can't you reproduce ?

Thanks
-- 
Francis
