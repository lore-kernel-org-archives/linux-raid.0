From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 04 Feb 2014 15:58:14 -0600
Message-ID: <52F16276.7040802@hardwarefreak.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com> <52EFAACE.40906@ubuntu.com> <52F05ECD.5060804@hardwarefreak.com> <52F12A93.50408@SGI.com> <52F12CA0.1030803@ubuntu.com> <52F134D3.20704@hardwarefreak.com> <52F13795.50408@ubuntu.com> <52F13C66.9030200@hardw
 arefreak.com> <52F14AA4.9020402@ubuntu.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F14AA4.9020402@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Larry Fenske <LFenske@SGI.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/4/2014 2:16 PM, Phillip Susi wrote:

> On 2/4/2014 2:15 PM, Stan Hoeppner wrote:
>> I never argued that the buffer cache path is slower.  It is in fact
>> much faster in most cases.
>>
>> I argued that accurately measuring the actual data throughput at
>> the disks isn't possible when writing through buffer cache.  At
>> least not in a straightforward manner as with O_DIRECT.  I've made
>> the point in the last two or three replies.  Yet instead of
>> directly addressing that, rebutting that, you keep making these
>> tangential irrelevant arguments...
> 
> You originally said "To significantly increase single streaming
> throughput you need AIO."  

Yes, I stated that in this post

http://www.spinics.net/lists/raid/msg45726.html

in the context of achieving greater throughput with an FIO job file
configured to use O_DIRECT, a job file I created, that the OP was using
for testing.  That job file is quoted further down in this same post,
and is included in my posts prior this one in the thread.  Apparently
you ignored them.  The context of my comment above is clearly
established multiple times earlier in the thread.

In my paragraph directly preceding the statement you quote above, I
stated this:

"Serial submission typically doesn't reach peak throughput...  You
usually must submit asynchronously or in parallel to reach maximum
throughput."

And again this is in the context of the FIO job file using O_DIRECT, and
this statement is factual.  As I repeated earlier today, O_DIRECT is
used because measuring actual throughput at the disks is
straightforward.  To increase O_DIRECT write throughput in FIO, you
typically need parallel submission or AIO.  This is well known.

> Now you appear to be saying otherwise.

No, I have not contradicted myself Phillip.  I've stated the same thing
until becoming blue in the face, and it's quite frustrating.

The fact of the matter is that you took a single sentence out of context
in a very long thread, and attacked it, attacked me, as being wrong,
when in fact I am, and have been, correct throughout.

Context matters, always.

-- 
Stan
