From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 1/8] raid5: add a per-stripe lock
Date: Tue, 12 Jun 2012 14:02:30 -0700
Message-ID: <CAA9_cmet-h8NUNGHff6EV_JRo=jqGFb_Q+RQ2Ep4ZDH9eymVtQ@mail.gmail.com>
References: <20120604080152.098975870@kernel.org>
	<20120604080300.519377228@kernel.org>
	<20120607105410.415d9fe6@notabene.brown>
	<20120607062939.GA779@kernel.org>
	<20120607163522.71c68e23@notabene.brown>
	<20120607065224.GE779@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120607065224.GE779@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Wed, Jun 6, 2012 at 11:52 PM, Shaohua Li <shli@kernel.org> wrote:
> On Thu, Jun 07, 2012 at 04:35:22PM +1000, NeilBrown wrote:
>> On Thu, 7 Jun 2012 14:29:39 +0800 Shaohua Li <shli@kernel.org> wrote=
:
>>
>> > On Thu, Jun 07, 2012 at 10:54:10AM +1000, NeilBrown wrote:
>> > > On Mon, 04 Jun 2012 16:01:53 +0800 Shaohua Li <shli@kernel.org> =
wrote:
>> > >
>> > > > Add a per-stripe lock to protect stripe specific data, like de=
v->read,
>> > > > written, ... The purpose is to reduce lock contention of conf-=
>device_lock.
>> > >
>> > > I'm not convinced that you need to add a lock.
>> > > I am convinced that if you do add one you need to explain exactl=
y what it is
>> > > protecting.
>> > >
>> > > The STRIPE_ACTIVE bit serves as a lock and ensures that only one=
 process can
>> > > be in handle_stripe at a time.
>> > > So I don't think dev->read actually needs any protection (though=
 I haven't
>> > > checked thoroughly).
>> > >
>> > > I think the only things that device_lock protects are things sha=
red by
>> > > multiple stripes, so adding a per-stripe spinlock isn't going to=
 help remove
>> > > device_lock.
>> >
>> > This sounds not true to me. both the async callbacks and request c=
ompletion
>> > access stripe data, like dev->read. Such things are not protected =
by
>> > STRIPE_ACTIVE bit. Thought we can delete STRIPE_ACTIVE bit with st=
ripe lock
>> > introduced.
>>
>> Please give specifics. =A0What race do you see with access to dev->r=
ead that is
>> not protected by STRIPE_ACTIVE ?
>
> For example, ops_complete_biofill() will change dev->read which isn't=
 protected
> by STRIPE_ACTIVE. add_stripe_bio() checks ->toread ->towrite, which i=
sn't
> protected by the bit too. Am I missing anything?

STRIPE_ACTIVE is the replacement for the old per-stripe lock.  That
lock never was meant/able to synchronize add_stripe_bio() vs ops_run_*
(producer vs consumer).  That's always been device_lock's job because
an individual bio may be added to several stripes.  If device_lock is
gone we need a different scheme.  That's what tripped me up last time
I looked at this.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
