From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RAID 5 performance problems
Date: 03 Apr 2003 20:28:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1049398084.11742.88.camel@dhcp22.swansea.linux.org.uk>
References: <Pine.GSO.4.30.0304030858080.20118-100000@multivac.sdsc.edu>
	 <Pine.LNX.4.53.0304032104070.3085@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0304032104070.3085@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: "Peter L. Ashford" <ashford@sdsc.edu>, Jonathan Vardy <jonathan@explainerdc.com>, linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Iau, 2003-04-03 at 20:20, Stephan van Hienen wrote:
> > 2.  I/O bandwidth (multiple PCI buses)
> sure this helps, but he is not even getting near the pci bus
> limitations...

With mirrored software raid you are writing twice the data over
the PCI bus.

