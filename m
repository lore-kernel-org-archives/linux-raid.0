From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 2/8] raid5: lockless access raid5 overrided bi_phys_segments
Date: Tue, 12 Jun 2012 13:41:00 -0700
Message-ID: <CAA9_cmcyOaqS=amzO+rovCfDsnkMvm_ZYORT5=ZjGUzaY1L3mQ@mail.gmail.com>
References: <20120604080152.098975870@kernel.org>
	<20120604080307.401236650@kernel.org>
	<20120607110603.0d88c757@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120607110603.0d88c757@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Wed, Jun 6, 2012 at 6:06 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 04 Jun 2012 16:01:54 +0800 Shaohua Li <shli@kernel.org> wrote=
:
>
>> Raid5 overrides bio->bi_phys_segments, accessing it is with device_l=
ock hold,
>> which is unnecessary, We can make it lockless actually.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>
> I cannot say that I like this (casting fields in the bio structure), =
but I
> can see the value and it should work. =A0'atomic_t' is currently alwa=
ys the same
> size as an 'int', and I doubt that will change.
>
> So maybe I'll get used to the idea.

I think we should just bite the bullet and acknowledge that this field
has other meanings depending on the context and make it a union of int
and atomic_t..

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
