From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Rotating RAID 1
Date: Tue, 23 Aug 2011 00:05:47 -0400
Message-ID: <CALJXSJq52HG_50810mS-F1sfnCKgKsCBpqus9NZ_Le_Rc70JTw@mail.gmail.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
 <4E497FB5.3030109@ivitera.com> <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
 <4E49849E.4030604@ivitera.com> <20110816084251.2d8e7831@notabene.brown>
 <CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com>
 <20110816095517.757afc07@notabene.brown> <CALJXSJqYXmvfoperm10XCLnGNA4WgMt_y7UoUSgPv3xjqScNcg@mail.gmail.com>
 <20110823135812.62c56cee@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110823135812.62c56cee@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 22, 2011 at 11:58 PM, NeilBrown <neilb@suse.de> wrote:
> More concrete details would help...

Sorry, you're right, I though it could have been something fast.
I have details for the first test I made with 15 RAIDs.

>
> So you have 8 MD RAID1s each with one missing device and the other de=
vice is
> the next RAID1 down in the stack, except that last RAID1 where the on=
e device
> is a real device.

Exactly, only 1 real device at the moment.

>
> And in some unspecified test the RAID1 at the top of the stack gives =
2/3 the
> performance of the plain device? =C2=A0This the same when all bitmaps=
 are
> removed.
>
> Certainly seems strange.
>
> Can you give details of the test and numbers etc.

So the test is a backup, Veeam exactly, using Samba 3.6.0 with brand
new SMB2 protocol, bitmaps are removed.
The backup took 45 minutes instead of 14 to 22 minutes.

Here is a sample of iostat showing the average queue size increasing
by RAID devices:
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00    35.67    0.00   27.00     0.00  5579.00
413.26     2.01   74.69    0.00   74.69  34.32  92.67
md64              0.00     0.00    0.00   61.33     0.00  5577.00
181.86     0.00    0.00    0.00    0.00   0.00   0.00
md65              0.00     0.00    0.00   60.00     0.00  5574.67
185.82     0.00    0.00    0.00    0.00   0.00   0.00
md66              0.00     0.00    0.00   58.67     0.00  5572.33
189.97     0.00    0.00    0.00    0.00   0.00   0.00
md67              0.00     0.00    0.00   58.67     0.00  5572.33
189.97     0.00    0.00    0.00    0.00   0.00   0.00
md68              0.00     0.00    0.00   58.67     0.00  5572.33
189.97     0.00    0.00    0.00    0.00   0.00   0.00
md69              0.00     0.00    0.00   58.67     0.00  5572.33
189.97     0.00    0.00    0.00    0.00   0.00   0.00
md70              0.00     0.00    0.00   58.33     0.00  5572.00
191.04     0.00    0.00    0.00    0.00   0.00   0.00
md71              0.00     0.00    0.00   57.00     0.00  5569.67
195.43     0.00    0.00    0.00    0.00   0.00   0.00
md72              0.00     0.00    0.00   55.67     0.00  5567.33
200.02     0.00    0.00    0.00    0.00   0.00   0.00
md73              0.00     0.00    0.00   54.33     0.00  5565.00
204.85     0.00    0.00    0.00    0.00   0.00   0.00
md74              0.00     0.00    0.00   53.00     0.00  5562.67
209.91     0.00    0.00    0.00    0.00   0.00   0.00
md75              0.00     0.00    0.00   51.67     0.00  5560.33
215.24     0.00    0.00    0.00    0.00   0.00   0.00
md76              0.00     0.00    0.00   50.33     0.00  5558.00
220.85     0.00    0.00    0.00    0.00   0.00   0.00
md77              0.00     0.00    0.00   49.00     0.00  5555.67
226.76     0.00    0.00    0.00    0.00   0.00   0.00
md78              0.00     0.00    0.00   47.67     0.00  5553.33
233.01     0.00    0.00    0.00    0.00   0.00   0.00
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
