From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Thu, 14 Apr 2011 18:23:39 -0400
Message-ID: <4DA773EB.5030005@turmel.org>
References: <270234.74664.qm@web65113.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <270234.74664.qm@web65113.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/14/2011 05:12 PM, Gavin Flower wrote:

> 
> Hi Phil,
> 
> I was under the impression that I had an adequate power supply, so I checked all 5 drives.  In fact I made a table to compare all the smart entries.  The differences I thought were significant follow later.  I have the full comparison table, and the original smart output, in an OpenDocument file - which I will attach to a separate email (in case it gets blocked/dropped or some such).
> 
> Note that Power_Cycle_Count is anomalous only for /dev/sdc, so would this suggest cable problems?

No two drives are perfectly identical, so when the drive's power rail is only slightly overloaded, the least tolerant drive chokes as the voltage declines (we're talking tens of milliseconds, here).  As soon as it chokes, the extra load disappears, and the power supply recovers.  The other drives carry on.  The drive that choked resets (*Click*) in time for the block driver to try again, and the cycle repeats.

As a test, borrow another power supply and hook just that one drive to it.  If the problem continues, the drive is toast.  If the problem goes away, look for a better power supply.  Note:  for the Barracuda with the problem, the detailed spec says the 5V load spikes on activity, not the 12V load.  So make sure the current capacity of the power supply meets your needs for both 5V & 12V (plus your motherboard).  Also check if the power supply has multiple regulators for drive power, and if you need to re-arrange the connectors to spread the load evenly amongst them.

As another test, you can swap all your cables around.  If the problem is in the cables, the problem will follow the cables to the drive you moved them to.

> I am not sure what to make of the other discrepancies.
> 
> Note that sda, sdb, sdd, & sde were bought and put in at the same time, while sdc was only obtained and inserted recently.

So sdc came from a different manufacturing batch, which is likely to have slightly different tolerances.

HTH,

Phil
