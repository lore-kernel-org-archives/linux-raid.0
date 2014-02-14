From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Fri, 14 Feb 2014 15:35:57 -0500
Message-ID: <52FE7E2D.8020308@turmel.org>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Florian Lampel <florian.lampel@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Florian,

On 02/14/2014 11:19 AM, Florian Lampel wrote:
> Greetings,
> 
> The title says it all: 2 days before my RAID6 lost a HDD (sdh). Not  a problem, I thought, just let it reassemble and be done with it.
> 
> Unfortunately, my Mainboard-Controller didn't seem to like that, and after about 2 hours into the rebuilding process it showed me that the array was missing 5 drives ( 4 from the MB-Controller and the one that went south before).
> Being a Admin for quite a while, I did not panic and have not issued a single command that writes to the RAID in any form as of yet.
> 
> Having read the wiki page about broken RAID arrays reading some messages on the list it became obvious that I should check with you guys before I do anything. The Server is still running, but I intend to restart it after unplugging an SATA cable that I assume to be faulty.
> 
> Here are the relevant logs and outputs of mdadm as requested on the Wiki:
> 
> h__p://pastebin.com/1xweaLYG

Good report.  It even includes the mapping of serial numbers to devices!

To consolidate some critical parts:

sda1: WD-WMC300595645 probably device 8
sdb1: WD-WMC300314217 probably device 9
sdc1: WD-WMC300595957 probably device 10
sdd1: WD-WMC300313432 probably device 11
sde1: WD-WMC300595440 Active device 4
sdf1: WD-WMC300595880 Active device 5
sdg1: WD-WMC1T1521826 Active device 6
sdh1: WD-WMC300314126 spare, incomplete device 7
sdj1: WD-WMC300312702 Active device 0
sdk1: WD-WMC300248734 Active device 1
sdl1: WD-WMC300314248 Active device 2
sdm1: WD-WMC300585843 Active device 3

> sda, sdb, sdc and sdd can't be reached anymore by any means. I believe a restart might fix this, but I am not sure.
> 
> 2) I assume that I should do the following, in this order: 
> 
> 2.1) restart the machine and check all the cables etc.
> ---> and hope that /dev/sda, sdb, sdc and sdd will talk to me again.

Keep replacing controllers, cables, power supplies (anything except the
drives) until you can communicate with all of them.

Except /dev/sdh.  It wasn't finished syncing, so is no help.

Figure out what went wrong with the hardware.  After you get them all
talking, show us the missing mdadm --examine data and an exhaustive
smartctl report:

mdadm -E /dev/sd[abcd]1 >pastebin.txt

for x in /dev/sd[a-z] ; do echo $x : ; smartctl -x $x ; done >>pastebin.txt

> 2.2) mdadm --assemble --scan 
> ---> and hope for the best. I don't think it will work.

Don't bother.  It certainly won't work now that four drives will have
different event counts.  "--scan" is less than useful in these cases, too.

> 2.3 madm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 (since the Event count is the same) /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1
> --> I don't believe this one will work, too. When using --force, is the sequence of the HDDs in the command important?

This is the right tool.  Order doesn't matter, as the metadata carries
the member ID.  Leave out /dev/sdh1 (or wherever WD-WMC300314126 ends up).

mdadm -Afv /dev/md0 /dev/sd[abcdefgjklm]1

If it fails, show us the output.

> 2.4) mdadm --create --assume-clean --chunk=512 --metadata=1.0 --level 6 --raid-devices=12 --size=1953512960 /dev/md0 /dev/sdj1 /dev/sdk1 /dev/sdl1 etc. (using the sequence numbers of the /proc/mdstat pasted above)

Do *not* do this!  You have metadata.  You have enough drives to run the
array.  Re-creating the array is *madness*.

HTH,

Phil
