From: Phil Turmel <philip@turmel.org>
Subject: Re: question about the best suited RAID level/layout
Date: Fri, 05 Jul 2013 22:19:59 -0400
Message-ID: <51D77ECF.5090909@turmel.org>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>  <51D6CBF9.2020100@turmel.org> <1373073066.10569.30.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373073066.10569.30.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/05/2013 09:11 PM, Christoph Anton Mitterer wrote:
> On Fri, 2013-07-05 at 09:36 -0400, Phil Turmel wrote:
>> You picked "redundancy".  Leaves only only one axis to consider: speed
>> vs. capacity.
> Well thinking about that "raid6check" tool you told me over in the other
> thread,...
> which AFAIU does what I was talking about, namely telling me which block
> is the correct one if I have bad blocks (and the disk itself can't tell)
> and not whole drive failures,.. where at least a two-block copy RAID10
> would not be able to...
> ...then I think RAID6 is THE solution for me, given resilience has the
> highest priority, as RAID10 with c/f/o=3 cannot do that.

I think you should read Neil's blog entry before you get too excited
about raid6check.  You can only trust its decisions when you are
confident that the problems it finds are *only* due to silent read
errors.  MD raid does not carry the per-block metadata needed to
distinguish silent read errors from incomplete writes or out-of-band
writes to member disks.

Hopefully, btrfs will fill this void (eventually).

http://neil.brown.name/blog/20100211050355

Phil
