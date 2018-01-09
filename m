From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Tue, 9 Jan 2018 09:36:49 +0000
Message-ID: <5A548D31.4000002@youngman.org.uk>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180108220139.GB16421@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/01/18 22:01, Dave Chinner wrote:
> Yup, 21 devices in a RAID 10. That's a really nasty config for
> RAID10 which requires an even number of disks to mirror correctly.
> Why does MD even allow this sort of whacky, sub-optimal
> configuration?

Just to point out - if this is raid-10 (and not raid-1+0 which is a
completely different beast) this is actually a normal linux config. I'm
planning to set up a raid-10 across 3 devices. What happens is that is
that raid-10 writes X copies across Y devices. If X = Y then it's a
normal mirror config, if X > Y it makes good use of space (and if X < Y
it doesn't make sense :-)

SDA: 1, 2, 4, 5

SDB: 1, 3, 4, 6

SDC: 2, 3, 5, 6

Cheers,
Wol
