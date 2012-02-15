From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Wed, 15 Feb 2012 07:30:45 -0600
Message-ID: <4F3BB385.4000608@hardwarefreak.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com> <20120215083058.GA8821@cthulhu.home.robinhill.me.uk>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120215083058.GA8821@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/15/2012 2:30 AM, Robin Hill wrote:
> On Tue Feb 14, 2012 at 05:27:43PM -0600, Stan Hoeppner wrote:
> 
>> Maybe I simply don't understand this 'magic' of the f2 and far layouts.
>>  If you only read the "faster half" of a spindle, does this mean writes
>> go to the slower half?  If that's the case, how can you read data that's
>> never been written?
>>
> Writes go to both halves, as normal for a mirrored setup, which is why

Huh?  A 'normal' RAID setup mirrors one disk to another.  You're
describing data being mirrored from the outer half of a single disk to
the inner half.  Where's the Redundancy in this?  This doesn't make sense.

> its write performance is lower than that of a near layout array (more
> head movement required). Reads will (normally) come from the faster
> (outer) half of the disk though, so read performance is better. In most
> cases workloads are read-heavy, so this comes out as a significant gain.

Again, this makes no sense.  You're simply repeating what David said.
Neither of you seem to really understand this, or are simply unable to
explain it correctly, technically.

Maybe Neil will jump into the fray and answer my original question.

-- 
Stan
