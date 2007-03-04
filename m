From: Iustin Pop <iusty@k1024.org>
Subject: Re: Unexpectedly slow raid1 benchmark results.
Date: Sun, 4 Mar 2007 13:52:38 +0100
Message-ID: <20070304125238.GA3118@teal.hq.k1024.org>
References: <003801c75e5b$7db61bb0$bc01a8c0@apmsafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <003801c75e5b$7db61bb0$bc01a8c0@apmsafe.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan <kasper37@netzero.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 04, 2007 at 04:47:19AM -0800, Dan wrote:
> Just about the only stat in these tests that show a marked improvement between
> one and two drives is Random Seeks (which makes sense).  What doesn't make sense
> is that none of the Sequential Input numbers increase.  Shouldn't I be seeing
> close to a 100% improvement?

This is not raid0! Since the drives are identical copies, you can't
really optimize the sequential input since the input data is not
stripped... OTOH, if you have two processes doing sequential input, then
yes, each drive should work close or at the normal sequential input
speed.

Regards,
Iustin
