From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Hard drive Reliability?
Date: Thu, 20 May 2004 09:54:35 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <D9C3AB0C3EE2254099B606A10047B5F60C3165@hdsmsx403.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: jim@rubylane.com, Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


One aspect that hasn't been mentioned, is that disk drives are arguably
the most complex component in the computer, and that the pressure to
release new, faster, bigger, cheaper disks at increasingly shorter
release cycles means that disk vendors have to leverage existing parts
and firmware code to do this, and also some risk is involved.  It's
actually pretty amazing that they get it done as well as they do (some
better than others).  However, updated disk firmware releases are often
important to maintain disk reliability.  

Disk handling damage is a common problem, but usually mishandling occurs
from lack of care by others in the chain, not the disk vendor.  

Disclaimer:  I'm not directly associated with any disk vendor, but I
have had lots of test & support experience with a variety of disk drives
(mostly SCSI).  

Andy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of jim@rubylane.com
Sent: Thursday, May 20, 2004 9:27 AM
To: Mark Hahn
Cc: linux-raid@vger.kernel.org
Subject: Re: Hard drive Reliability?


> you imply that vendors are knowingly shipping half their product
> that will die within even a 1yr warranty period, and then have 
> to be replaced at significant cost to the vendor.  I really can't 
> see why you think they're so stupid!  the alternate explanation,
> which fits the data (such as it is) perfectly well is that the 
> supply chain damages the drives.

I don't believe that theory, because Maxtor has replaced some of
our failed drives, directly, and the replacements also failed in
less than a year.

It takes a lot of time for an end-user to do an RMA.  With drives
costing around $100, it's much cheaper to buy a new drive and replace
it than to go through the drive manufacturer's RMA process.  I don't
believe drive manufacturers are stupid at all...

One thing the drive manufacturers could do to help is publish MTBF
figures for a range of duty cycles.  If they say "this drive will fail
in 8 months if you do an average of 50 seeks per second throughout the
day", then people will know that the drives may not be up to the task.
Or "this drive will last 15 years if you just turn it on and never
access it."

Jim

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
