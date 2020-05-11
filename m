From: pg@lxraid.list.sabi.co.UK (Peter Grandi)
Subject: Re: raid6check extremely slow ?
Date: Mon, 11 May 2020 23:44:11 +0100
Message-ID: <24249.54587.74070.71273@base.ty.sabi.co.uk>
References: <20200510120725.20947240E1A@gemini.denx.de>
        <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
        <20200511064022.591C5240E1A@gemini.denx.de>
        <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com>
        <20200511161415.GA8049@lazy.lzy>
        <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> With lock / unlock, I get around 1.2MB/sec per device
>>> component, with ~13% CPU load.  Wihtout lock / unlock, I get
>>> around 15.5MB/sec per device component, with ~30% CPU load.

>> [...] we still need to avoid race conditions. [...]

Not all race conditions are equally bad in this situation.

> 1. Per your previous reply, only call raid6check when array is
> RO, then we don't need the lock.
> 2. Investigate if it is possible that acquire stripe_lock in
> suspend_lo/hi_store [...]

Some other ways could be considered:

* Read a stripe without locking and check it; if it checks good,
  no problem, else either it was modified during the read, or it
  was faulty, so acquire a W lock, reread and recheck it (it
  could have become good in the meantime).

  The assumption here is that there is a modest write load from
  applications on the RAID set, so the check will almost always
  succeed, and it is worth rereading the stripe in very rare
  cases of "collisions" or faults.

* Variants, like acquiring a W lock (if possible) on the stripe
  solely while reading it ("atomic" read, which may be possible
  in other ways without locking) and then if check fails we know
  it was faulty, so optionally acquire a new W lock and reread
  and recheck it (it could have become good in the meantime).

  The assumption here is that the write load is less modest, but
  there are a lot more reads than writes, so a W lock only
  during read will eliminate the rereads and rechecks from
  relatively rare "collisions".

The case where there is at the same time a large application
write load on the RAID set and checking at the same time is hard
to improve and probably eliminating rereads and rechecks by just
acquiring the stripe W lock for the whole duration of read and
check.
