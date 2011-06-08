From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH/RFC] md/raid10: optimize read_balance() for 'far copies' arrays
Date: Wed, 08 Jun 2011 23:39:31 +0900
Message-ID: <87ei349yl8.fsf@gmail.com>
References: <1307516445-3208-1-git-send-email-namhyung@gmail.com>
	<20110608172157.4d6ac2a8@notabene.brown> <877h8w93bw.fsf@gmail.com>
	<20110608114924.GA10134@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608114924.GA10134@www2.open-std.org> ("Keld =?utf-8?Q?J?=
 =?utf-8?Q?=C3=B8rn?=
	Simonsen"'s message of "Wed, 8 Jun 2011 13:49:25 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?utf-8?Q?J=C3=B8rn?= Simonsen <keld@keldix.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen <keld@keldix.com> writes:
> On Wed, Jun 08, 2011 at 04:42:27PM +0900, Namhyung Kim wrote:
>> Still can't understand why we choose the closest-to-the-start disk i=
n
>> case we could have possible sequencial access on other disk. Probabl=
y
>> because of the lack of my understanding how md/disk works :(
>
> the nearest position was the case for the initial implementation of
> raid10-far.  But this had bad performance for an array with disks of
> varying specifications. And also it led to not using the faster
> outer sectors. Using the closest-to-beginning gave a spped-up of abou=
t
> 50 % in some cases.
>

Hi Keld,

Thanks for the explanation. That means lower sectors reside on the oute=
r
tracks/cylinders in the disk, right? The 50% seems a huge improvement I
couldn't stand against. Although my patch tried to choose
closest-to-current-head disk if the disk head is in the lowest stripe -
in the (similar) hope that it'd be on the outer tracks - I don't have
the numbers, so I'll just give up on it.

Besides, I just noticed that the rationale behind read_balance()
pressumed that all components of the array are traditional disks. If we
could detect all/some of them are not (i.e. SSD, etc.), it would be
better off using some other criteria for the read balancing IMHO,
something like nr_pending?

--=20
Regards,
Namhyung Kim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
