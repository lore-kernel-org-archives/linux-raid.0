From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Wed, 16 Feb 2011 17:32:58 -0600
Message-ID: <4D5C5EAA.3020208@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5A7198.7060607@hardwarefreak.com> <ijdvmn$4ff$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijdvmn$4ff$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Brown put forth on 2/15/2011 7:39 AM:

> This brings up an important point - no matter what sort of system you get (home
> made, mdadm raid, or whatever) you will want to do some tests and drills at
> replacing failed drives.  Also make sure everything is well documented, and well
> labelled.  When mdadm sends you an email telling you drive sdx has failed, you
> want to be /very/ sure you know which drive is sdx before you take it out!

This is one of the many reasons I recommended an enterprise class vendor
solution.  The Nexsan unit can be configured for SMTP and/or SNMP and/or pager
notification.  When a drive is taken offline the drive slot is identified in the
GUI.  Additionally, the backplane board has power and activity LEDs next to each
drive.  When you slide the chassis out of the rack (while still fully
operating), and pull the cover, you will see a distinct blink pattern of the
LEDs next to the failed drive.  This is fully described in the documentation,
but even without reading such it'll be crystal clear which drive is down.  There
is zero guess work.

The drive replacement testing scenario you describe is unnecessary with the
Nexsan products as well as any enterprise disk array.

> You also want to consider your raid setup carefully.  RAID 10 has been mentioned
> here several times - it is often a good choice, but not necessarily.  RAID 10
> gives you fast recovery, and can at best survive a loss of half your disks - but
> at worst a loss of two disks will bring down the whole set.  It is also very
> inefficient in space.  If you use SSDs, it may not be worth double the price to
> have RAID 10.  If you use hard disks, it may not be sufficient safety.

RAID level space/cost efficiency from a TCO standpoint is largely irrelevant
today due to the low price of mech drives.  Using the SATABeast as an example,
the cost per TB of a 20TB RAID 10 is roughly $1600/TB and a 20TB RAID 6 is about
$1200/TB.  Given all the advantages of RAID 10 over RAID 6 the 33% premium is
more than worth it.

-- 
Stan
