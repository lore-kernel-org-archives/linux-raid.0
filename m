From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 18:40:17 -0500
Message-ID: <4DCF12E1.1020809@hardwarefreak.com>
References: <20110513202900.GA1926@apartia.fr> <4DCE99D0.1010900@hardwarefreak.com> <20110514151812.GA3074@apartia.fr> <4DCEC7C0.80306@hardwarefreak.com> <20110514191532.GA15753@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514191532.GA15753@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/14/2011 2:15 PM, Louis-David Mitterrand wrote:

> My system partiton is fine, thank you very much. Only my data partition
> is affected by the geometry inconsistency. And the performance
> difference was quickly obvious: 22 seconds to untar kernel sources vs 20
> minutes.

If there are no errors then that's not a controller issue but a problem
with barrier and cache configuration.  This exact issue came up on the
XFS list not 2 months ago.  Having barriers enabled on a BBWC card was
the OP's problem.

And, BTW, you should enable the XFS delaylog mount option if you haven't
already.  This will drop big metadata operation run time by another
order of magnitude.

If you want a pure SAS/SATA HBA without fakeRAID, this may be an option
worth looking at:

http://www.newegg.com/Product/Product.aspx?Item=N82E16816101358
http://www.supermicro.com/manuals/other/AOC-SASLP-MV8.pdf

Simple JBOD only HBA, no fakeRAID.  Uses a Marvell 88SE6480 chip, 8
SAS/SATA ports via two SFF8087.  $110 USD.  I've heard minor rumblings
WRT the mvsas driver though I don't recall specifics.  The board itself
is good quality, as with most things SuperMicro.

-- 
Stan
