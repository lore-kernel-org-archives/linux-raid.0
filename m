From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: Small chunk size read performance penalty
Date: Mon, 19 Aug 2013 00:49:13 -0500
Message-ID: <kusbkh$il1$1@ger.gmane.org>
References: <kurge6$qi0$1@ger.gmane.org> <521177A2.2010704@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <521177A2.2010704@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/18/2013 08:40 PM, Stan Hoeppner wrote:
> Can you elaborate on your workload that demonstrates this?  Different
> workloads behave differently with different chunk sizes.

dd ... at block sizes between 4KiB and 1MiB, on RAID-5 and -6 arrays
with chunk sizes in the same range.

Hardware is 5 7200 RPM SATA drives in a NAS (Thecus N5550) with an Atom
D2550 processor and an ICH10R chipset.  The drives are all connected to
the chipset's built-in AHCI controller.

> If you can see it, then please demonstrate this read penalty with
> numbers.  You obviously have test data from the same set of disks with
> two different RAID5s of different chunk sizes.  This is required to see
> such a difference in performance.  Please share this data with us.

I've uploaded the data (in OpenDocument spreadsheet form) to Dropbox.  I
think that it's accessible at this link:

  https://www.dropbox.com/s/4dq93th4wu5rr2y/nas_benchmarks.ods

(This is my first attempt at sharing anything via Dropbox, so let me
know if it doesn't work.)

I actually find your response really interesting.  From my Interweb
searching, the "small stripe size read penalty" seems to be pretty
widely accepted, much as the "large stripe size write penalty" is.  It
certainly does show up in my data; as the chunk size increases reads of
even small blocks get faster.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

