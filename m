From: Phil Turmel <philip@turmel.org>
Subject: Re: Interpreting mdstat output
Date: Tue, 05 Feb 2013 08:54:55 -0500
Message-ID: <51110F2F.1080504@turmel.org>
References: <20130205122048.GA417@nsrc.org> <20130205130237.GA9299@cthulhu.home.robinhill.me.uk> <20130205134014.GA587@nsrc.org> <20130205134907.GA622@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130205134907.GA622@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/2013 08:49 AM, Brian Candler wrote:
> On Tue, Feb 05, 2013 at 01:40:14PM +0000, Brian Candler wrote:
>> On Tue, Feb 05, 2013 at 01:02:37PM +0000, Robin Hill wrote:
>>>> 1. The UUUU_ and [22/21] suggests that one disk is bad, but is that true?
>>>> And if so which one?
>>>>
>>> No, that's normal. A RAID5 (or RAID6) array is created in a degraded
>>> form, then the last disk(s) are recovered (it's the quickest way of
>>> getting the array ready for use).
>>
>> Ah I see. Thank you.
> 
> The odd thing is, if I make a RAID6 I get [UUUUU] with no underscores?
> 
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
> md127 : active raid6 sdy[23](S) sdx[22] sdw[21] sdv[20] sdu[19] sdt[18] sds[17] sdr[16] sdq[15] sdp[14] sdo[13] sdn[12] sdm[11] sdl[10] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>       61532835840 blocks super 1.2 level 6, 512k chunk, algorithm 2 [23/23] [UUUUUUUUUUUUUUUUUUUUUUU]
>       [>....................]  resync =  0.0% (850232/2930135040) finish=1607.7min speed=30365K/sec
>       bitmap: 22/22 pages [88KB], 65536KB chunk

Raid6 resyncs to get started where raid5 rebuilds to get started.

Regular parity is computationally identical to create from the data and
to compute one data from the parity and the rest.  So reading linearly
from all drives but one, and writing linearly to just one is the fastest
way to start raid5.

The Q syndrome in raid6 is not symmetrical.  It is more expensive to
compute data from Q, so raid6 doesn't try to do that on creation.

Phil

