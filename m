From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Upgrading storage server
Date: Tue, 10 Feb 2015 18:22:04 +1100
Message-ID: <54D9B19C.9060505@websitemanagers.com.au>
References: <54D8A9AD.3060700@websitemanagers.com.au> <21721.30729.509462.974269@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21721.30729.509462.974269@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/02/15 14:16, John Stoffel wrote:
> Adam> After making a whole string of mistakes in building a iSCSI
> Adam> server about 2 years ago, I'm now looking to replace it without
> Adam> all the wrong turns/mistakes. I was hoping you could all offer
> Adam> some advice on hardware selection/choices.
>
> I remember those discussions, they were quite informative and it was
> interesting seeing Stan help you out.  Now that you've got this system
> working well, or at least well enough, what is the biggest remaining
> problem you have?
The only current requirement is to get some sort of DR 
configuration/setup in place, that doesn't involve restoring from 
backups. Performance is satisfactory right now, so I don't want to hit 
any new performance issues in the process.

> I've become a big fan of supermicro FatTwin systems, and they might be
> what you want here for your setup.  But I'd also think about maybe you
> want to go to fewer larger PCIe SSD cards in mirrored pairs instead
> for better performance.  Or is performance a problem still?
The users are satisfied with the current performance level, though I 
suspect if performance could be improved without drastically increasing 
the cost, then it would make sense as well.

Those FatTwin systems look pretty awesome, but since I only need two 
systems (nodes) and ideally I want one in each rack, then it doesn't 
quite work out. I tend to prefer white box systems, due to it being 
easier to find replacement parts, and I am avoiding too much redundancy 
within each system (eg dual power, raid6, etc) as I am relying on the 
second node to take over, allowing the primary to be repaired and added 
back in later.

> There's also *alot* to be said for simply replicating what you have,
> but with larger SSDs, say 1Tb each, and keeping the rest of the system
> and config exactly the same.  Limit the changes, esp since you went
> through so much pain before.
That was my thoughts, although I assume motherboards, CPU's, and perhaps 
SATA controller cards have changed a lot over the past 3 years (although 
I note that Intel suggests the motherboard isn't EOL until this year). 
I'd prefer to get current models of hardware so that they will be well 
supported (ie, replacements are easy to get) for the next few years. 
Basically, at the same time as adding DR capability, I will be 
refreshing the model of hardware. I suppose repeating this process every 
3 years means that the DR hardware will be up to 6 years old, which is 
probably still satisfactory (unless I see a lot of failures there), 
considering that there is still a replicated pair (as long as they don't 
both fail at the same time, or lose 2 "disks" each at the same time).
> Now I might also think about upgrading all the clients to 10Gb as
> well, and just moving to a completely 10G network if possible.  I seem
> to remember that you didn't have any way to throttle or setup Quality
> of Service limits on your iSCSI vs. other network traffic, which is
> why you ended up splitting up the traffic like this, so that a single
> VM couldn't bring the rest to their knees when a user did something
> silly.
Well, I split the iSCSI SAN and the user LAN partly to satisfy "best 
practice", improve security, as well as obviously 
performance/reliability. I don't think I'll upgrade all the VM servers 
to 10G at this stage (aren't planning to replace them all for another 6 
months or more). At that stage, it might be something to consider, but I 
would still be concerned about one VM "hogging" all the disk bandwidth. 
Perhaps in practice, it wouldn't be an issue, since it is more IOPS that 
is the limiting factor, and you can steal all available IOPS without 
using very much bandwidth. This will likely depend on the cost/ability 
to get a 16 port (or minimum of 10port) 10Gbps switch. Maybe something 
like this:
http://www.netgear.com.au/business/products/switches/smart/10g-smart-switch.aspx#tab-overview 
at approx AUD$1800

> So again, if it's working well now, don't chage your architecture at
> all, just change some of the components for higher capacity or
> performance.  This will also let you stress test the new cluster pair
> next to your production setup before you migrate the VMs over to the
> new setup and then move the old offsite.
I'm haven't properly thought about how to do the migration, but I would 
think I can bring up one of the new servers, and replace the current 
"secondary" in the DRBD. Then, when that has settled in (for a week or 
so), I can flip it to become the primary. Again, allow to test for a 
week or so (any issues I can easily flip it back to secondary and so 
revert back to the known good status), and then remove the second old 
server, and replace with the second new server. Finally, reconfigure 
both old servers onsite with the DRBD proxy config. Once that is working 
well, (and obviously all the data is synced up to date) I can move them 
offsite.
> One warning is that you will need to make sure that the link between
> the two sites has enough bandwidth and low enough RTT so that you can
> properly replicate between them, esp if the end users will be
> generating a bunch of data that changes alot.

Yep, that is something I'm looking into at the moment. Supposedly with 
drbdproxy, as long as the changed data per day is less than the 
bandwidth per day, then it should work. Also, this will relate to how 
much RAM is available on the drbdproxy node to cache the changes.

I'm actually struggling a little with getting the "right" data for this. 
Currently, I'm pulling all the data from /proc/drbd into an RRD file 
(for each drbd device). Hopefully I'm a little crazy, but if I do this:
rrdtool fetch ${i} AVERAGE -s -25h |grep -v nan|tail -288| cut -d' ' 
-f3| awk '{s+=$1}END{print s}'

Which should select the past 25 hours worth of 5 minute averages, then 
remove the unknowns at the end (because the rrd file is only updated 
every 30 minutes, the values are cached), and then pick only the last 24 
hours of reports (288), pick out the nr (network read) value, sum all 
those to get the total of the 5 minute average data read over the 
network (by the secondary). Finally, I multiply this by 300 to get the 
actual data transferred. (Assuming that a 5 minute average is 3MB/s, 
therefore the original amount of data transferred is 3 x 300 = 900MB in 
5minutes).
The problem is I got an answer of over 200GB, which isn't going to fit 
on my WAN  (max 10Mbps, or 1MB/s), unless I upgrade the WAN, or 
compression works really well, or my calculations are entirely wrong.....

Anyway, this section is somewhat off-topic for here. I'll follow up the 
DRBD side elsewhere.

Thanks for your comments/suggestions.

Regards,
Adam

> Adam> The target usage as above is an iSCSI server as the backend to a bunch
> Adam> of VM's. Currently I have two identical storage servers, using 7 x SSD
> Adam> with Linux MD Raid, then using LVM to divide it up for each VM, and then
> Adam> DRBD on top to sync the two servers together, on the top is ietd to
> Adam> share the multiple DRBD devices out. The two servers have a single
> Adam> 10Gbps connection between them for DRBD to sync the data. They also have
> Adam> a second 10Gbps ethernet for iscsi to use, with a pair of 1Gbps for
> Adam> management (on board). I have 8 x PC's running Xen with 2 x 1Gbps
> Adam> ethernet for iSCSI and one 1Gbps ethernet for the "user"/management LAN.
>
> Adam> Current hardware of the storage servers are:
> Adam> 7 x Intel 480GB SSD Model SSDSC2CW480A3
> Adam> 1 x Intel 180GB SSD Model SSDSC2CT180A4  (for the OS)
> Adam> 1 x LSI Logic SAS2308 PCI-Express (8 x SATA connections)
> Adam> 1 x Intel Dual port 10Gbps 82599EB SFI/SFP+ Ethernet
> Adam> 1 x Intel Xeon CPU E3-1230 V2 @ 3.30GHz
> Adam> Motherboard Intel S1200
> Adam> http://ark.intel.com/products/67494/Intel-Server-Board-S1200BTLR
>
> Adam> What I'm hoping to achieve is to purchase two new (identical) servers,
> Adam> using current recommended (and well supported for the new few years)
> Adam> parts, and then move the two existing servers to a remote site,
> Adam> combining with DRBD proxy to give a full, "live" off-site backup
> Adam> solution. (Note, by backup I mean Disaster Recovery, not backup).
>
> Adam> I would also like to be able to grow the total size of the data further
> Adam> if needed, currently I have 7 x 480G in RAID5, which is likely somewhat
> Adam> sub-optimal. Options include moving to larger size SSD, or at perhaps
> Adam> splitting into 2 x RAID5 arrays. The advantage of larger SSD's would be
> Adam> a smaller "system", with lower complexity, while using more smaller
> Adam> drives would provide (potentially) better performance, since each drive
> Adam> (regardless of size) has the same overall performance (both throughput
> Adam> and IOPS).
>
> Adam> I would appreciate any advise or suggestions you can make to help me
> Adam> avoid the many mistakes I made last time.
>

-- 
Adam Goryachev
Website Managers
P: +61 2 8304 0000                    adam@websitemanagers.com.au
F: +61 2 8304 0001                     www.websitemanagers.com.au

