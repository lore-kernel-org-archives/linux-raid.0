From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Thu, 06 Jan 2005 09:41:28 +0400
Message-ID: <41DCCF88.10809@wasp.net.au>
References: <Pine.LNX.3.96.1050105023623.27288A-100000@Maggie.Linux-Consulting.com> <41DBC7DE.509@wasp.net.au> <20050105141251.GE13684@harddisk-recovery.com> <41DBFBAE.1070309@tls.msk.ru> <20050105171104.GG13684@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050105171104.GG13684@harddisk-recovery.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Alvin Oga <aoga@ns.Linux-Consulting.com>, Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Erik Mouw wrote:
> On Wed, Jan 05, 2005 at 05:37:34PM +0300, Michael Tokarev wrote:
> 
>>Erik Mouw wrote:
>>
>>>If you have a  bad block in your swap partition and the device doesn't
>>>report an error about it, no amount of RAID is going to help you
>>>against it.
>>
>>The drive IS reporting read errors in most cases. 
> 
> 
> "most cases" and "all cases" makes quite a difference.
> 

Actually it *was* reporting *all* read errors. It was an early Maxtor 1GB drive and these have been 
notoriuosly bad for being problematic *however* they have been frightfully good at accurately 
reporting exactly what was wrong. In this case I was pretty new to the Linux sysadmin thing and 
never actually really noticed the disk errors in the syslog and correlated them to the process 
dying. (it was a fair few years ago now).

I actually have never had an ATA disk develop errors it did not report.

My point remains the same. By putting your swap on a RAID (of any redundant variety) you are 
increasing the chances of machine survival against disk errors, be they single bit, bad block or 
dead drive.

Talking of Maxtor drives. I have a unit here with less than 6000 hours on it that has started 
growing bad sectors at an alarming rate. All accurately reported by SMART mind you (clever little 
disk), but after running a badblocks -n on it (to really shake them loose) the reallocated sector 
count has halved! Now how can a drive un-reallocate dud sectors?

Brad
