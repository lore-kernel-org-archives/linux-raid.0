From: Michael McCallister <mike@mccllstr.com>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Mon, 12 Apr 2010 06:17:22 +0000 (UTC)
Message-ID: <loom.20100412T080748-841@post.gmane.org>
References: <loom.20100411T185315-118@post.gmane.org> <k2o4877c76c1004111431v147791a7weea96497f6d0431d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans <mjevans1983 <at> gmail.com> writes:
> I'd use smartctl to get the drive serial numbers, then move what are
> currently shown as sdb5 and sdd5 to your new controller during a
> coldboot.

Thanks.  I did this and was able to boot and reassemble successfully with a live
CD.  However, the question in the back of my mind is "is there any way to tell
whether this would have worked with one of the controllers down?"  In other
words, if I just pulled the plug on sdb and sdd instead of moving them to a new
controller, would the array have been able to be reassembled in a degraded mode
with only sda and sdc?  Or would it actually need a different combination of
drives (e.g., sda and sdb) to be able to reassemble?

Obviously I could try this, but if I am able to reassemble an array with two
drives missing, won't I have to resync the other drives when I return them to
the array?  I'd rather avoid experiments involving resyncs if possible.


Mike


