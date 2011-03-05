From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID6 seemingly shrunk itself after hard power outage and rebuild
 with replacement disk
Date: Sat, 05 Mar 2011 02:32:43 -0600
Message-ID: <4D71F52B.7030701@hardwarefreak.com>
References: <robbat2-20110304T221807-988505787Z@orbis-terrarum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <robbat2-20110304T221807-988505787Z@orbis-terrarum.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, robbat2@gentoo.org
List-Id: linux-raid.ids

Robin H. Johnson put forth on 3/4/2011 5:27 PM:

> After a rebuild following disk replacement, the MD array (RAID6, 12 devices)
> appears to have shrunk by 10880KiB.
----------------------------------------------------------------------------------
> The entry in /proc/partitions noted the array size of 14651023360KiB, while
> older LVM backups showed the usable size of the array to previously be
> 14651034240KiB, a difference of 10880KiB.
----------------------------------------------------------------------------------
> Prior to the outage, 800KiB of the collected devices was used for metadata, and
> post the outage, now 11680KiB is used (difference of 10880 KIB).
----------------------------------------------------------------------------------
> Why did the array shrink?

It appears it shrunk by exactly the size of the new metadata, 10880KiB,
if this is actually considered an array shrink.  It seems you need to
identify why the metadata size increased, and figure out a way to revert
it back to its previous size.

Your current metadata version is 1.2.  What was it prior to the
catastrophic UPS event?

-- 
Stan
