From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
Date: Wed, 16 Jan 2008 11:55:37 -0500 (EST)
Message-ID: <alpine.DEB.0.999999.0801161154150.16168@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: xfs@oss.sgi.com, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Wed, 16 Jan 2008, Justin Piszcz wrote:

> For these benchmarks I timed how long it takes to extract a standard 4.4 GiB 
> DVD:
>
> Settings: Software RAID 5 with the following settings (until I change those 
> too):

http://home.comcast.net/~jpiszcz/sunit-swidth/newresults.html

Any idea why an sunit and swidth of 0 (and -d agcount=4) is faster at least
with sequential input/output than the proper sunit/swidth that it should be?

It does not make sense.

Justin.

