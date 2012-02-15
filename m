From: keld@keldix.com
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Wed, 15 Feb 2012 10:24:27 +0100
Message-ID: <20120215092426.GA29612@www5.open-std.org>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3AEDEF.2000608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 14, 2012 at 05:27:43PM -0600, Stan Hoeppner wrote:
> Maybe I simply don't understand this 'magic' of the f2 and far layouts.
>  If you only read the "faster half" of a spindle, does this mean writes
> go to the slower half?  If that's the case, how can you read data that's
> never been written?

Think of raid10,f2 as two raid0's - the first raid0 is on the outer faster
tracks, the second on the slower inner tracks. Reads are always from the outer tracks
so the performance is that of raid0, including striping, and because it is only the
outer tracks, faster and with less head movement than a raid0 on the full set of spindles.

Writes are then written to both the raid0's (so you don't read data never written:-).
Writes are a bit slower it is said, as there should be more head movement, but that is
largely compensated by the spindle elevator algorithm for writes, which collects the output data
and orders the sectors so that they can be written in sequence, minimizing head movement.
With the elevator you can actually have striping writes too.
Also writes are less time critical than reads, as you do not wait on them to get things processed in the CPUs.
You just collect the output buffers and then periodically flush the data.

Best regards
Keld
