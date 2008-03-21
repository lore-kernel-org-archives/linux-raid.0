From: Ric Wheeler <ric@emc.com>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Fri, 21 Mar 2008 10:02:12 -0400
Message-ID: <47E3BFE4.6030609@emc.com>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <20080320173906.GN32242@skl-net.de> <20080320180241.GJ13719@mit.edu>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080320180241.GJ13719@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Cc: Andre Noll <maan@systemlinux.org>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>
List-Id: linux-raid.ids

Theodore Tso wrote:
> On Thu, Mar 20, 2008 at 06:39:06PM +0100, Andre Noll wrote:
>> On 12:35, Theodore Tso wrote:
>>
>>> If a mismatch is detected in a RAID-6 configuration, it should be
>>> possible to figure out what should be fixed
>> It can be figured out under the assumption that exactly one drive has
>> bad data and all other ones have good data. But that seems to be an
>> assumption that is hard to verify in reality.
> 
> True, but it's what ECC memory does.  :-)   And most people agree that
> it's a useful thing to do with memory.  
> 
> If you do ECC syndrome checking on every read, and follow that up with
> periodic scrubbing so that you catch (and correct) errors quickly, it
> is a reasonable assumption to make.
> 
> Obviously a warning should be given when you do this kind of ECC
> fixups, and if there is an increasing number of ECC fixups that are
> being done, that should set off alarms that maybe there is a hardware
> problem that needs to be addressed.
> 
> Regards,
> 
> 						- Ted

This might have been stated before in the thread, but most of the raid 
rebuilds are triggered by easily identified drive failures (i.e., a 
completely dead drive or a sequence of bad sectors that generate an IO 
error as we read from the platter). Fortunately, these are also the most 
common failures in RAID boxes ;-)

The way you deal with class of errors that don't trigger obvious 
failures is to do some kind of background scrubbing or add extra 
protection data to the disk.

Martin Petersen presented the new "DIF" work at the FS/IO workshop. This 
might be an interesting feature to build into MD raid devices:

http://oss.oracle.com/projects/data-integrity/documentation/

You would need to reformat your drives, so this is not a generic 
solution for all users, but it really does address the core of the issue.

ric
