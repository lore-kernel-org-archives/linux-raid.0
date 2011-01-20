From: Paul Clements <paul.clements@us.sios.com>
Subject: Re: [BUG 2.6.32] md/raid1: barrier disabling does not work correctly
 in all cases
Date: Thu, 20 Jan 2011 15:44:21 -0500
Message-ID: <AANLkTimN2FOp5X353AfJqnMTL-1nhQH=4uNFt5GNAa7d@mail.gmail.com>
References: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
	<AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
	<20110121072515.07dc2b74@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110121072515.07dc2b74@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 20, 2011 at 3:25 PM, NeilBrown <neilb@suse.de> wrote:

> Normally the first thing that md/raid1 writes to a member device is t=
he
> metadata. =A0This is written with a barrier write if possible. =A0If =
that fails
> then barriers_work is cleared, so all barrier writes from the filesys=
tem
> (empty or otherwise) will be rejected.

Yes, I noticed that, and assume that's why more people haven't seen
this problem...

> As you are getting an error here I assume that you are using non-pers=
istent
> metadata - correct?

Yep, that's right...

> Nonetheless, I think the correct fix is to add a special case for ret=
rying a
> zero-length.

> Something like this maybe?

Thanks Neil. I will try this patch.

--
Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
