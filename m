From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: More ddf container woes
Date: Fri, 11 Mar 2011 12:50:16 +0100
Message-ID: <4D7A0C78.2080402@gmail.com>
References: <4D5FA5C4.8030803@gmail.com>	<4D63688E.5030501@gmail.com>	<20110223171712.09509f9e@notabene.brown>	<4D67ECA2.2020201@gmail.com> <20110303093136.586df7e7@notabene.brown> <4D788D2D.80706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D788D2D.80706@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  More experiments with the same setup

On 03/10/11 09:34 AM, Albert Pauw wrote:
>  Hi Neil,
>
> I found some more trouble with the ddf code, separate from the stuff I 
> mentioned before (which is still present in the version I used below).
>
> Here's what I did and found:
>
> Note: Updated mdadm from the git repository up to and including the 
> commit "Manage:  be more careful about --add attempts."
>
> Used six disks, sdb - sdg out of which I created a 5-disk container, 
> leaving one disk unused for the moment:
>
> mdadm -C /dev/md127 -l container -e ddf -n 5 /dev/sd[b-f]
>
> Created two RAID sets in this container:
>
> mdadm -C /dev/md0 -l 1 -n 2 /dev/md127
> mdadm -C /dev/md1 -l 5 -n 3 /dev/md127
>
> Note: At this moment, only one mdmon is running (mdmon md127)
>
> After finishing creating both RAID sets, I fail two disks, one in each 
> RAID set:
>
> mdadm -f /dev/md0 /dev/sdb
>
> mdadm -f /dev/md1 /dev/sdd
>
> The first failed disk (sdb) is automatically removed from /dev/md0, 
> but oddly enough the disk stays marked as
> "active/Online" in the "mdadm -E /dev/md127" output, the second failed 
> disk (sdd) gets marked [F] in the RAID 5
> array, but NOT removed, only when I do a
>
> mdmon --all
>
> the failed disk in /dev/md1 is removed, this second failed disk IS 
> marked "Failed" in the "mdadm -E output".
>
> Note: Checking on the RAID arrays using "mdadm -D" they are both 
> marked as "clean, degraded".

I now failed the disk in reverse order, first the RAID5 set (md1), then 
the RAID 1 set (md0), and the behaviour was different.

Now both disks stay marked failed [F] in the subarrays (md0 and md1). 
Doing a "mdadm -E /dev/md127" shows all disks
"active/Online", so the container isn't told of the failure of the 
disks. Only after a "mdmon --all" both failed disks are removed
from their respective array. "mdadm -E /dev/md127" now shows both disks 
as failed, so the container knows about the failed disks now.

When I don't run "mdmon --all" and want to add a spare disk it fails 
with the message "mdadm: add failed for /dev/sdg: mdmon not running".

The rest of the response stays the same. Adding a clean new disk to the 
container makes both subarrays going into recovery with this
new disk, md1 first and after finishing this, md0 gets resynched (with 
the same disk!).

When I fail two disks of the RAID 5 set (md1), so the whole subarray is 
failed, and then add a spare disk to the container, only md0 (the RAID 1 
set)
picks it up, md1 doesn't get rebuild (and that's who it should be).

>
> I now add a new empty clean disk (/dev/sdg) to the container, after 
> which md1 (the RAID 5 set) is immediately starting to rebuild.
> The RAID 1 set (md0), however, is set to "resync=DELAYED", very odd, 
> because I only added one disk.
>
> Looking at the output of /proc/mdstat i see that disk sdg (the new 
> spare) is actually added to both RAID
> arrays, and after finishing the rebuild of md1 the other RAID set 
> (md0) is also rebuild, using the SAME spare disk (sdg).
>
>
> Albert
>

To sum it up, there are two problems here:

- A failed disk in a subarray isn't automatically removed and marked 
"Failed" in the container, although in some cases it does (see above).
Only after a manual "mdmon --all" will this take place.

- When two subarrays have failed disks, are degraded, but operational 
and I add a spare disk to the container, both will pick up the spare
disk for replacement. They won't do this in parallel, but in sequence, 
but nevertheless use the same disk.

Albert


