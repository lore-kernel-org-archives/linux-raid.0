From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: raidtools vs mdadm
Date: Wed, 1 Sep 2004 10:54:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16693.7624.576505.965545@cse.unsw.edu.au>
References: <8075D5C3061B9441944E1373776451186488CB@cinshrexc03.shermfin.com>
	<1093989799.3399.27.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rich turner on Tuesday August 31
To: rich turner <rich@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 31, rich@storix.com wrote:
> are there any incompatibilities related to mdadm? does it only support
> the md driver at a certain level? our software supports kernel version
> 2.2 and later.

mdadm should support everything, though I haven't tested it much on
2.2.  The "--assemble" functionality has to be implemented very
differently in 2.2.  I don't know how well it works.

> 
> does it fully support creating a raid device on logical volumes, and
> creating logical volumes on raid devices? i have played with this a
> little and havent seen any problems but i thought i would ask to see if
> anyone has seen anything.

It creates raid arrays on anything, and the raid arrays can be used
for anything.  The arrays created with mdadm are indistinguishable
from arrays created with raidtools.

> 
> would i expect to see the mdadm executable available on most
> distributions today by default?

I think so.  It depends on what you mean by "default".
On debian, it isn't part of the base distribution, but nor is
raidtools.  "apt-get" gets it easily.

> 
> i realize that raid devices created with raidtools and raid devices
> created with mdadm can co-exist. is there an easy way to know which
> method was used to create them?

It is impossible to know.  There is no difference.

NeilBrown
