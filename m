From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums)
 to make it more robust
Date: Wed, 18 Jul 2012 22:48:05 -0500
Message-ID: <50078375.7050208@hardwarefreak.com>
References: <691e878b-1a0d-4042-bb92-c8af76ba063b@zmail15.collab.prod.int.phx2.redhat.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <691e878b-1a0d-4042-bb92-c8af76ba063b@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/18/2012 8:04 AM, Jaromir Capik wrote:

> Unfortunately many drives do that. This happens transparently
> during the drive's idle surface checks, 

Please list the SATA drives you have verified that perform firmware self
initiated surface scans when idle, and transparently (to the OS)
relocate bad sectors during this process.

Then list the drives that have relocated sectors during such a process
for which they could not read all the data, causing the silent data
corruption you describe.

> I experienced data corruptions related to bad sector reallocations
> in case of several different desktop drives.

Please name the drives, make/model/manufacturer, the drive count of the
array, and the array type used when these silent corruptions occurred.

For one user to experience silent corruption once is extremely rare.  To
experience it multiple times within a human lifetime is statistically
impossible, unless you manage very large disk farms with high cap drives.

If your multiple silent corruptions relate strictly to RAID1 pairs, it
would seem the problem is not with the drives, but lay somewhere else.
Unless you're using some el cheapo 3rd rate Asian sourced white label
drives nobody ever heard of.  One such company flooded the market with
such drives in the mid 90s.  I've not heard of anything similar since,
but that doesn't mean such drives aren't in the wild.

-- 
Stan

