From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 12:19:45 +0000
Message-ID: <CADNH=7EjNQT9O1T3Kz42H4PbfPzrwW+Y1wO1AjFydVZABenH=Q@mail.gmail.com>
References: <11510711257.20121028131527@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11510711257.20121028131527@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Rainer_F=C3=BCgenstein?= <rfu@oudeis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28 October 2012 12:15, Rainer F=C3=BCgenstein <rfu@oudeis.org> wrote=
:
>
> when trying to upgrade my raid5 with 4 Western digital caviar green
> 3TB drives [WDC WD30EZRX-00MMMB0] (3 brandnew, 1 about 4months old),
> the "old" drive and one of the brand new ones failed with
> unrecoverable read errors and about 70 reallocated sectors each. the
> failures already occured during the initial resync after creating the
> raid.
>
> until now I was very fond of WD caviar green drives, but after this
> 50% failure rate I'm not very eager to restore data from the backup.
>
> what is your experience with 3TB drives, WD and others?
>
> (low power drives appreciated, performance is not an issue)
>
> tnx.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Just a few days earlier, I posted on this list, with 2 WD20EARS dives
failing in my RAID6 array. It doesn't matter much if you have them
spinning all the time or not, with age and stress (rebuilds) they
just... die, often.

If you REALLY care about the data, go for enterprise drives, or at
least stay away from green / eco drives.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
