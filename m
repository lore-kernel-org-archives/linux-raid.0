From: pg@lx.to.sabi.co.UK (Peter Grandi)
Subject: Re: super slow reshape speed after power failure
Date: Thu, 20 Dec 2012 14:32:15 +0000
Message-ID: <20691.8559.262520.841910@tree.ty.sabi.co.UK>
References: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
	<20690.985.485075.572934@tree.ty.sabi.co.UK>
	<CA+Z7oPgp_fu3sFzJefoTzvd-eQUCv7qqS38ZkHes3EqysuM8Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Z7oPgp_fu3sFzJefoTzvd-eQUCv7qqS38ZkHes3EqysuM8Ng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>>> [ ... ]  reshape was running it was running around 4mb/s,
>>> which is slow to begin with. [ ... resync too ... ]

>> A bigger value for 'md/stripe-cache' might help, alleviating
>> some alignment issues, but usually it is not like 10 times
>> better, but might be still worthwhile even if it will be still
>> slow.

> I tried values up to 32768, but no difference.

Then probably the partitions are really misaligned.

Anyhow a wev search for similar cases shows in some cases higher
reshape and resync rates, but not enormously higher, and usually
'stripe_cache' helps, at least with the reshape.

Perhaps disabling barriet might help if they are enabled, but
that would be quite dangerous, as you already had a crash during
reshape.

It may be good to reassemble the array with '--freeze-reshape'
to allow it to resync without interference from reshaping,
hopefully faster, and then '--continue' after resyning has
ended.
