From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 18:11:04 +0100
Message-ID: <20050105171104.GG13684@harddisk-recovery.com>
References: <Pine.LNX.3.96.1050105023623.27288A-100000@Maggie.Linux-Consulting.com> <41DBC7DE.509@wasp.net.au> <20050105141251.GE13684@harddisk-recovery.com> <41DBFBAE.1070309@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41DBFBAE.1070309@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Brad Campbell <brad@wasp.net.au>, Alvin Oga <aoga@ns.Linux-Consulting.com>, Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 05, 2005 at 05:37:34PM +0300, Michael Tokarev wrote:
> Erik Mouw wrote:
> >If you have a  bad block in your swap partition and the device doesn't
> >report an error about it, no amount of RAID is going to help you
> >against it.
> 
> The drive IS reporting read errors in most cases. 

"most cases" and "all cases" makes quite a difference.

> And please, pretty PLEASE stop talking about those mysterious
> "undetectable" or "unreported" errors here.  A drive that develops
> "unreported" errors just does not work and should not be here in
> the first place, just like bad memory or CPU: if your cpu or memory
> is failing, no software tricks helps and the failing part should
> be replaced BEFORE even thinking about possible ways to recover.

Indeed: any suspicious part should not be used in the recovery process.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
