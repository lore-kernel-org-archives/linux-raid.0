From: Iustin Pop <iusty@k1024.org>
Subject: Re: raid1 does not seem faster
Date: Mon, 9 Apr 2007 14:17:42 +0200
Message-ID: <20070409121742.GB7016@teal.hq.k1024.org>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr> <200704011558.31670.a1426z@gawab.com> <46118473.10205@tmr.com> <200704031642.27701.a1426z@gawab.com> <461430B6.9060703@tmr.com> <20070405045819.GA5525@teal.hq.k1024.org> <Pine.LNX.4.64.0704050410290.12619@p34.internal.lan> <Pine.LNX.4.64.0704090652230.15675@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704090652230.15675@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 09, 2007 at 06:53:26AM -0400, Justin Piszcz wrote:
> Using 2 threads made no difference either.
> 
> It was not until I did 3 simultaneous copies that I saw 110-130MB/s 
> through vmstat 1, until then, it only used one drive, even with two cp's, 
> how come it needs to be three or more?

Because, as I understand it, it's an optimisation, not a rule. Quoting
from the manpage (md):
"Once initialised, each device in a RAID1 array contains exactly the
same data.  Changes are written to all devices in parallel.  Data is
read from any one device.  The driver attempts to distribute read
requests across all devices to maximise performance."

The key word here is "attempts". I looked a while ago over the source
code and IIRC it says that it tries to direct a read request to the
drive whose head is closest to the requested sector, or if not possible
a random drive. To me, this seems a good strategy, which optimises
server-type workloads.

regards,
iustin
