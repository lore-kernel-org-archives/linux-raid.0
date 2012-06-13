From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 1/8] raid5: add a per-stripe lock
Date: Tue, 12 Jun 2012 21:08:47 -0700
Message-ID: <CAA9_cmck7gNVGk4ZX-nG-L5u8Xvw8J_7ne-inggh-rcgHTCY_g@mail.gmail.com>
References: <20120604080152.098975870@kernel.org>
	<20120604080300.519377228@kernel.org>
	<20120607105410.415d9fe6@notabene.brown>
	<20120607062939.GA779@kernel.org>
	<20120607163522.71c68e23@notabene.brown>
	<20120607065224.GE779@kernel.org>
	<CAA9_cmet-h8NUNGHff6EV_JRo=jqGFb_Q+RQ2Ep4ZDH9eymVtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmet-h8NUNGHff6EV_JRo=jqGFb_Q+RQ2Ep4ZDH9eymVtQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Tue, Jun 12, 2012 at 2:02 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Wed, Jun 6, 2012 at 11:52 PM, Shaohua Li <shli@kernel.org> wrote:
>> On Thu, Jun 07, 2012 at 04:35:22PM +1000, NeilBrown wrote:
>>> On Thu, 7 Jun 2012 14:29:39 +0800 Shaohua Li <shli@kernel.org> wrot=
e:
>>>
>>> > On Thu, Jun 07, 2012 at 10:54:10AM +1000, NeilBrown wrote:
>>> > > On Mon, 04 Jun 2012 16:01:53 +0800 Shaohua Li <shli@kernel.org>=
 wrote:
>>> > >
>>> > > > Add a per-stripe lock to protect stripe specific data, like d=
ev->read,
>>> > > > written, ... The purpose is to reduce lock contention of conf=
->device_lock.
>>> > >
>>> > > I'm not convinced that you need to add a lock.
>>> > > I am convinced that if you do add one you need to explain exact=
ly what it is
>>> > > protecting.
>>> > >
>>> > > The STRIPE_ACTIVE bit serves as a lock and ensures that only on=
e process can
>>> > > be in handle_stripe at a time.
>>> > > So I don't think dev->read actually needs any protection (thoug=
h I haven't
>>> > > checked thoroughly).
>>> > >
>>> > > I think the only things that device_lock protects are things sh=
ared by
>>> > > multiple stripes, so adding a per-stripe spinlock isn't going t=
o help remove
>>> > > device_lock.
>>> >
>>> > This sounds not true to me. both the async callbacks and request =
completion
>>> > access stripe data, like dev->read. Such things are not protected=
 by
>>> > STRIPE_ACTIVE bit. Thought we can delete STRIPE_ACTIVE bit with s=
tripe lock
>>> > introduced.
>>>
>>> Please give specifics. =A0What race do you see with access to dev->=
read that is
>>> not protected by STRIPE_ACTIVE ?
>>
>> For example, ops_complete_biofill() will change dev->read which isn'=
t protected
>> by STRIPE_ACTIVE. add_stripe_bio() checks ->toread ->towrite, which =
isn't
>> protected by the bit too. Am I missing anything?
>
> STRIPE_ACTIVE is the replacement for the old per-stripe lock. =A0That
> lock never was meant/able to synchronize add_stripe_bio() vs ops_run_=
*
> (producer vs consumer). =A0That's always been device_lock's job becau=
se
> an individual bio may be added to several stripes. =A0If device_lock =
is
> gone we need a different scheme. =A0That's what tripped me up last ti=
me
> I looked at this.

Actually now that I look at add_stripe_bio again, I think it could be
made to work if:

1/ bi_phys_segments is incremented prior to publishing the bio on
to{read|write} otherwise we potentially race with a consumer without a
reference

2/ making sure the overlap checking does not walk off into invalid
bios as it may do once we no longer have a global lock

Outside of that we need a lock for making sure bi->next fields are
updated properly and two threads only collide there on the same
stripe.  But I need to think more about the other usages.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
