From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 17:37:34 +0300
Message-ID: <41DBFBAE.1070309@tls.msk.ru>
References: <Pine.LNX.3.96.1050105023623.27288A-100000@Maggie.Linux-Consulting.com> <41DBC7DE.509@wasp.net.au> <20050105141251.GE13684@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050105141251.GE13684@harddisk-recovery.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Brad Campbell <brad@wasp.net.au>, Alvin Oga <aoga@ns.Linux-Consulting.com>, Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Erik Mouw wrote:
> On Wed, Jan 05, 2005 at 02:56:30PM +0400, Brad Campbell wrote:
> 
>>I beg to differ on this one. Having spend several weeks tracking down 
>>random processes dying on a machine that turned out to be a bad sector in 
>>the swap partition, I have had great results by running swap on a RAID-1. 
>>If you develop a bad sector in a non-mirrored swap, bad things happen 
>>indeterminately and can be a royal PITA to chase down. It's just a little 
>>extra piece of mind.
> 
> If you have a  bad block in your swap partition and the device doesn't
> report an error about it, no amount of RAID is going to help you
> against it.

The drive IS reporting read errors in most cases.  But that does not
help, really: kernel swapped out some memory but can't read it back,
so things are screwed.  Just like if you hot-remove a DIMM while the
system is running: the kernel loses parts of it's memory, and it can't
work anymore.  Depending on what was in there ofcourse: the whole
system may be screwed, or a single process...  The talks isn't about
"undetectable" (unreported etc) errors here, but about the fact that
the error is here.  And if your swap is on raid, in case one component
of the array behaves badly, another component will continue to work,
so with swap on raid the system will work just fine as if nothing
happened in case one of "swap components" (i mean underlying devices)
failed for whatever reason.

And please, pretty PLEASE stop talking about those mysterious
"undetectable" or "unreported" errors here.  A drive that develops
"unreported" errors just does not work and should not be here in
the first place, just like bad memory or CPU: if your cpu or memory
is failing, no software tricks helps and the failing part should
be replaced BEFORE even thinking about possible ways to recover.

/mjt
