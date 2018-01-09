From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Tue, 9 Jan 2018 23:32:07 +0100
Message-ID: <540ae436-b3d2-9fbc-f38c-1cc3fede7728@thelounge.net>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180109222523.GJ16421@dastard>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 09.01.2018 um 23:25 schrieb Dave Chinner:
> On Tue, Jan 09, 2018 at 09:36:49AM +0000, Wols Lists wrote:
>> Just to point out - if this is raid-10 (and not raid-1+0 which is a
>> completely different beast) this is actually a normal linux config. I'm
>> planning to set up a raid-10 across 3 devices. What happens is that is
>> that raid-10 writes X copies across Y devices. If X = Y then it's a
>> normal mirror config, if X > Y it makes good use of space (and if X < Y
>> it doesn't make sense :-)
>>
> IMO, odd-numbered disks in RAID-10 should be considered harmful and
> never used....

agreed and then "writemostly" could work without the lame excues that 
one could have a crazy RAID10 layout.....

https://www.spinics.net/lists/raid/msg55797.html
