From: Lapohos Tibor <tibor.lapohos@rogers.com>
Subject: Re: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Wed, 6 Jan 2010 08:18:43 -0800 (PST)
Message-ID: <195985.49531.qm@web88208.mail.re2.yahoo.com>
References: <4589525.I9CuDL8pqf@rnqqfki.eternal-september.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4589525.I9CuDL8pqf@rnqqfki.eternal-september.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your reply, Antonio.

--- On Wed, 1/6/10, Antonio Perez <ap23563m@gmx.com> wrote:

> What's the output of:
> =A0=A0=A0 fdisk -lu /dev/sda

I will look at it tonight. Thanks.

> However, the way you are making partitions is quite complex
> and the needed space could be somewhere else.

Does this mean that this partitioning is not the right way to proceed? =
should I create all the partitions first and build them into so many /d=
ev/md[01234] devices separately maybe?

> Please, stop repeating your question everywhere.

I am very sorry if I upset the community. I did not think that linux-ra=
id, grub-devel and help-grub lists would represent the same experts. In=
 fact, based on what I see on the GRUB sites is, that grub-devel expert=
s are different from more like "legacy" supporting help-grub ones. Mayb=
e a bit of clarification would help keeping the developers/maintainers =
email intake a bit lower. So I must ask: which one is the most appropri=
ate for my question?

Thanks again,
Tibor

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
