From: "NeilBrown" <neilb@suse.de>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 12:57:16 +1100
Message-ID: <bf6312ba46da06f3801de738337990b2.squirrel@neil.brown.name>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
    <20091013013352.GA24869@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091013013352.GA24869@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: mark delfman <markdelfman@googlemail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, October 13, 2009 12:33 pm, Christoph Hellwig wrote:
> On Mon, Oct 12, 2009 at 05:58:20PM +0100, mark delfman wrote:
>> Hi... in recent tests we are seeing a 50% drop in performance from
>> XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)
>>
>> In short:  Performance to MD0 direct = circa 1.7GBsec (see below), via
>> xfs circa 850MBsec.  On previous system (2.6.28) there was no drop in
>> performance (in fact often an increase).
>>
>> I am hopefully that this is simply a matter of barriers etc on the
>> newer kernel and MD, but we have tried many options and nothing seems
>> to change this so would very much appreciate advice.
>
> Did barrier support for RAID0 got introduced in 2.6.30?

No, though it is due to go in for 2.6.33

NeilBrown

