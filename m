From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: Ooops on read-only raid5 while unmounting as xfs
Date: Tue, 23 Jan 2007 15:42:26 +0100
Message-ID: <fd8d0180701230642rd9d35e9y7e1058546254bad4@mail.gmail.com>
References: <fd8d0180701180218o66a48176q172b029673c22660@mail.gmail.com>
	 <17845.25989.10063.901037@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17845.25989.10063.901037@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > 3. mark the array read-only (mdadm -o)
>
> You shouldn't be able to do this.  It should only be possible to set
> an array to read-only when it is not in use.  The fact that you canno=
t
> suggests something else if wrong.
Should I ? I assumed that mdadm -o could be run with a running & used
array, and it seemed true. I never asked myself about -o semantics.
But I'll double-check as soon as possible. Anyway, if marking an array
-o is only possible when the array is not used, then it completely
changes my issue.

> Are you able to stop the array (mdadm -S) while the xfs filesystem is
> still mounte?d?
I guess not. I never managed, and I didn't either in this case. But I'l=
l try.

> >
> > May it be possible to relax the BUG_ON() and be able to send to
> > upper-layer a more gentle message ?
>
> Maybe... but I think I would rather make sure that you cannot set to
> read-only while mounted.
>
> If there some particular reason you were doing this?
Well, I was in a recovery process, I wanted to watch my data and mount
the xfs partition without altering the array.

My question is then : what prevents the upper layer to open the array
read-write, submit a write and make the md code BUG_ON() ?

>
> Thanks,
> NeilBrown
>

Thanks for your tips&answers,

=46ran=E7ois.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
