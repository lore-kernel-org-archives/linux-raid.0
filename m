From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: RFI for 2.6.25.5 : Re: Regression- XFS won't mount on partitioned
 md array
Date: Sat, 24 May 2008 10:39:34 -0500
Message-ID: <483836B6.8030406@sandeen.net>
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com> <4838192F.3050004@dgreaves.com> <20080524135258.GF6749@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080524135258.GF6749@1wt.eu>
Sender: linux-raid-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: David Greaves <david@dgreaves.com>, Greg KH <greg@kroah.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, LinuxRaid <linux-raid@vger.kernel.org>, stable@kernel.org
List-Id: linux-raid.ids

Willy Tarreau wrote:

> It would have helped to CC stable (fixed) and to give the mainline commit
> ID since the stable branch only holds already merged patches. Greg, the
> commit is 6ab455ee...
> 
> Willy

Yup I'll agree that this should probably go to -stable unless hch or
dchinner disagree.

FWIW I've already put it in the Fedora kernels.

-Eric
