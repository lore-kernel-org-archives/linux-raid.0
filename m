From: Hannes Reinecke <hare@suse.de>
Subject: Re: Which API for md state monitoring - sysfs vs. /proc/mdstat vs.
 GET_DISK_INFO ioctl
Date: Tue, 14 Feb 2017 16:26:09 +0100
Message-ID: <fb552c09-ec92-2ba3-fd91-052ff130ae8b@suse.de>
References: <994ffd50-9041-a5e0-bbd9-1db704f6ad63@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <994ffd50-9041-a5e0-bbd9-1db704f6ad63@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>, linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids

On 02/14/2017 03:43 PM, Tim Small wrote:
> Hello,
> 
> A design question for a user-space RAID monitoring tool.  The tool is
> intended to export machine-readable md state so that the system owners
> can creating automated alert policies etc.
> 
> Should it get its information on md device state from /proc/mdstat, or
> /sys/block/*/md/ as a data source, or should it use the ioctl interface
> that mdadm uses (on the basis that this is more complete / heavily tested).
> 
> I assume the issues are:
> 
> . usability (/proc/mdstat is intended to be human-readable so machine
> parsing it seems bleugh - it's also incomplete?)
> 
Yes.

> . stability (perhaps /sys/block/*/md/ is less stable than the ioctl or
> proc interface?  Or perhaps it's just fine and won't break in
> backward-incompatible ways?).
> 
I'm not sure if there are any guarantees here; we _try_ to keep the
sysfs interface stable, but ...

> Any thoughts?
> 
> Should I see which way the recent "add bad block flag to disk state"
> patch-set thread goes?
> 
Hehe.

Unfortunately the only tool able to provide a consistent view of the MD
RAID status is called 'mdadm'.

Problem is that you each of the various interfaces (ioctl, /proc/mdstat,
/sys/block/*/md) provides you with different information. So your
userspace tool would need to parse all of these information sources to
get a consistent view.

I did a similar thing myself for my md_monitor program
(github.com:/hreinecke/md_monitor.git), so you could have a look there
for some further information.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
