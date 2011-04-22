From: John Valarti <mdadmuser@gmail.com>
Subject: =?UTF-8?Q?Re=3A_Server_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assi?=
	=?UTF-8?Q?stance?=
Date: Thu, 21 Apr 2011 21:31:26 -0600
Message-ID: <BANLkTikneT0O5D0nV_8ZTMOs+SpKy3jMZQ@mail.gmail.com>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110422125734.1a68a736@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 21, 2011 at 8:57 PM, NeilBrown <neilb@suse.de> wrote:
=2E.
> Possibly.
>
> It looks like sdb2 failed in October 2009 !!!! and nobody noticed. =A0=
So your
> array has been running degraded since then.

Hmm, I would say "Oops" but I guess I am happy it was not my job to wat=
ch this.
> If you
>
> =A0mdadm -A /dev/md1 --force /dev/sd[acd]2
>
> Then you will have your array back,..

I will be grabbing a set of 4 new drives, plus a spare tomorrow morning=
=2E

Thanks VERY much for this!

> Also run "mdadm --monitor" configured to send you email if there is a=
 drive
> failure.

I will do some more reading to figure out how to do that I guess.
Good to know that is possible.

> =A0Also run "mdadm --monitor --oneshot" from a cron tab every day so
> that if you have a degraded array it will nag you about it every day.

More good stuff.
Is there a reasonably good book that one can read to learn this stuff?
I read the man pages and my head is still fuzzy.

> Good luck,
> NeilBrown

Thank you, and much obliged!
I **hope** I will not have to bug you any more about this.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
