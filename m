From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Rewrite md raid1 member
Date: Fri, 19 Aug 2016 12:52:21 +0100
Message-ID: <57B6F2F5.8090800@youngman.org.uk>
References: <20160818030451.GA17225@onthe.net.au>
 <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
 <20160818040151.GA21256@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160818040151.GA21256@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>, Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/08/16 05:01, Chris Dunlop wrote:
> I'm interested to see if there's a way of essentially doing the above on a
> live system, assuming there's appropriate care taken to not trash any
> existing data (including superblocks).
> 
> I.e. is it *theoretically* possible to write the same data back to the whole
> disk safely. E.g. using 'dd' from/to the same disk is almost there, but, as
> described, there's a window of opportunity where you could get stale data on
> the disk and a raid repair could then copy that stale data to the good disk.

There is something called "scrub". My superficial knowledge of raid
doesn't let me know what it is, but as far as I can make out it forces a
whole-disk-write or somesuch. Explicitly to flush out such problems. If
someone else can tell you how to scrub your disks, I'd try that.

It's especially recommended, I think, for people with desktop drives in
their array because it flushes out pending problems, which with desktop
drives typically remove the "R" from "raid".

Cheers,
Wol
