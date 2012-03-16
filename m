From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 12:21:50 +0000
Message-ID: <20323.12382.695317.414302@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
	<3633779.GerkmFcqtU@saturn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3633779.GerkmFcqtU@saturn>
Sender: linux-raid-owner@vger.kernel.org
To: Linux fs XFS <xfs@OSS.SGI.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> If you were in my place with the resource constraints, you'd
>> go with: xfs with barriers on top of mdraid10 with device
>> cache ON and setting vm/dirty_bytes, vm/dirty_background_bytes,
>> vm/dirty_expire_centisecs, vm/dirty_writeback_centisecs to
>> safe values

> If you ever experienced a crash where lots of sensible and
> important data were lost, you would not even think about
> "device cache ON".

It is not as simple as that... *If* hw barriers are implemented
*and* applications do the right things, that is not a concern.
Disabling the device cache is just a way to turn barriers on for
everything. Indeed the whole rationale for having the 'barrier'
option is to let the device caches on, and the OP did ask how to
test that barriers actually work.

Since even most consumers level drives currently implement
barriers correctly, the biggest problem today, as per the
O_PONIES discussions, is applications that don't do the right
thing, and therefore the biggest risk is large amounts of dirty
pages in system memory (either NFS client or server), not in the
drive caches.

Since the Linux flusher parameters are/have been demented, I
have seen one or more GiB of dirty pages in system memory (on
hosts I didn't configure...), which also causes performance
problems.

Again, as a crassly expedient thing, working around the lack of
"do the right thing" in applications by letting only a few
seconds of dirty pages accumulate in system memory seems to fool
enough users (and many system administrators and application
developers) into thinking that stuff is "safe". It worked well
enough for 'ext3' for many years, quite regrettably.

  Note: 'ext3' has also had the "helpful" issue of excessive
  impact of flushing, which made 'fsync' performance terrible,
  but improved the apparent safety for "optimistic" applications.
