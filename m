From: Beolach <beolach@gmail.com>
Subject: Re: reshape raid5 to raid6
Date: Wed, 24 Jun 2009 06:17:20 -0600
Message-ID: <aebf5d970906240517h783273b2t876fe2be09ef59d6@mail.gmail.com>
References: <20090624102729.GY2828@rlogin.dk>
	 <972c997a386db1106868b3dc6b29ee21.squirrel@neil.brown.name>
	 <aebf5d970906240515y6c616250lca1cedea32927b00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970906240515y6c616250lca1cedea32927b00@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 24, 2009 at 05:20, NeilBrown <neilb@suse.de> wrote:
>
> On Wed, June 24, 2009 8:27 pm, Michael Ole Olsen wrote:
> > Is it possible to reshape my /dev/md0 raid5 into raid6?
>
> If you are are using Linux 2.6.30, then you can
>
> =C2=A0echo raid6 > /sys/block/md0/md/level
>
> and it will instantly be sort-of-raid6.
> It is exactly like raid6 except that the Q blocks are all one
> the one drive, and drive that previously didn't exist.
> If you have a spare, it will start building the Q blocks
> on that drive and when it finishes you will have true raid6
> redundancy, though possibly a little less than raid6 performance,
> as a real raid6 has the Q block distributed.
>
> When mdadm-3.1 is released, you will be able to tell the raid6
> to re-stripe with a more traditional layout. =C2=A0This will take qui=
te
> a while, but you can continue to use the array (though a bit more
> slowly) will it progresses.
> Of course you don't need to do that step if you don't want to.

If a raid5 is changed to raid6, and then the raid6 is grown w/
additional disks, will that switch it to a more traditional layout,
since it has to be re-striped anyway?


TIA,
Conway S. Smith
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
