From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 15:12:51 +0100
Message-ID: <20050105141251.GE13684@harddisk-recovery.com>
References: <Pine.LNX.3.96.1050105023623.27288A-100000@Maggie.Linux-Consulting.com> <41DBC7DE.509@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41DBC7DE.509@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Alvin Oga <aoga@ns.Linux-Consulting.com>, Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 05, 2005 at 02:56:30PM +0400, Brad Campbell wrote:
> I beg to differ on this one. Having spend several weeks tracking down 
> random processes dying on a machine that turned out to be a bad sector in 
> the swap partition, I have had great results by running swap on a RAID-1. 
> If you develop a bad sector in a non-mirrored swap, bad things happen 
> indeterminately and can be a royal PITA to chase down. It's just a little 
> extra piece of mind.

If you have a  bad block in your swap partition and the device doesn't
report an error about it, no amount of RAID is going to help you
against it.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
