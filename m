From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
	reboot
Date: Tue, 23 Dec 2008 11:21:54 -0500
Message-ID: <20081223162154.GA30287@infradead.org>
References: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan> <20081223134247.GA17750@infradead.org> <alpine.DEB.1.10.0812230950120.7572@p34.internal.lan> <20081223145431.GA31057@infradead.org> <alpine.DEB.1.10.0812231043540.9812@p34.internal.lan> <49510BEF.2090209@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49510BEF.2090209@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, bug-parted@gnu.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Tue, Dec 23, 2008 at 10:03:59AM -0600, Eric Sandeen wrote:
> Justin Piszcz wrote:
> 
> 
> > Better question as well, need to find out if KNOPPIX or distro-CDs support 
> > this option, if one to boot into recovery and this option was not 
> > enabled.. that would not be fun.
> 
> I'd think most do... Fedora does, at least.

It might be time to have gpt partition support in the x86 defconfig, and
without CONFIG_PARTITION_ADVANCED.
