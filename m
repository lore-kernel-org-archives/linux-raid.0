From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Software RAID when it works and when it doesn't
Date: Thu, 18 Oct 2007 17:26:52 +0200
Message-ID: <87bqaw5tqb.fsf@informatik.uni-tuebingen.de>
References: <14526.1192571833@mdt.ecitele.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14526.1192571833@mdt.ecitele.com> (Mike Accetta's message of
	"Tue, 16 Oct 2007 17:57:13 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: Alberto Alonso <alberto@ggsys.net>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Accetta <maccetta@laurelnetworks.com> writes:

> Also, read errors don't tend to fail the array so when the bad disk is
> again accessed for some subsequent read the whole hopeless retry process
> begins anew.
>
> I posted a patch about 6 weeks ago which attempts to improve this situation
> for RAID1 by telling the driver not to retry on failures and giving some
> weight to read errors for failing the array.  Hopefully, Neil is still
> mulling it over and it or something similar will eventually make it into
> the main line kernel as a solution for this problem.

What I would like to see is a timeout driven fallback mechanism. If
one mirror does not return the requested data within a certain time
(say 1 second) then the request should be duplicated on the other
mirror. If the first mirror later unchokes then it remains in the
raid, if it fails it gets removed. But (at least reads) should not
have to wait for that process.

Even better would be if some write delay could also be used. The still
working mirror would get an increase in its serial (so on reboot you
know one disk is newer). If the choking mirror unchokes then it can
write back all the delayed data and also increase its serial to
match. Otherwise it gets really failed. But you might have to use
bitmaps for this or the cache size would limit its usefullnes.

MfG
        Goswin
