From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Intel X25-E running Linux using XFS
Date: Sat, 13 Dec 2008 12:43:53 +0100
Message-ID: <49439FF9.50202@s5r6.in-berlin.de>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan> <20081212185803.GE11974@elf.ucw.cz> <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Pavel Machek <pavel@suse.cz>, smartmontools-support@lists.sourceforge.net, smartmontools-database-owner@lists.sourceforge.net, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> On Fri, 12 Dec 2008, Pavel Machek wrote:
>> Actually I'd like to know... how does it behave during powerfails
>> while it is being written to?
>>
>> Flashes I seen (USB / SD) developed bad sectors in that case, and
>> ext2/ext3 can't handle that. (And I don't think xfs can handle that
>> either).
> 
> I have a UPS for all of my machines, so that will not be a problem in my
> case.

UPSs fail too.

...
> With barriers, presumably it would be safe

There are other opinions:  http://lwn.net/Articles/309576/
(Magnetic disks are discussed there.)
-- 
Stefan Richter
-=====-==--- ==-- -==-=
http://arcgraph.de/sr/
