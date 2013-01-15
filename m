From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 23:55:07 +1100
Message-ID: <20130115125507.GA12184@rabbit.us>
References: <20130115123301.GA11948@rabbit.us>
 <50F55046.7050605@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50F55046.7050605@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 15, 2013 at 07:49:10AM -0500, Phil Turmel wrote:
> You are neglecting each drive's need to skip over parity blocks.  If the
> array's chunk size is small, the drives won't have to seek, just wait
> for the platter spin.  Larger chunks might need a seek.

> Either way, you
> won't get better than (single drive rate) * (n-2) where "n" is the
> number of drives in your array. (Large sequential reads.)

This can't be right. As far as I know the md layer is smarter than that, and
includes various anticipatory codepaths specifically to leverage multiple
drives in this fashion. Fwiw raid5 does give me the near-expected speed
(n * single drive).

Cheers

