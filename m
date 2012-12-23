From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Disk speed comparison
Date: Sat, 22 Dec 2012 22:59:44 -0600
Message-ID: <50D68FC0.70807@hardwarefreak.com>
References: <27374116.4.1356197991689.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27374116.4.1356197991689.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/22/2012 11:39 AM, Roy Sigurd Karlsbakk wrote:

> I have an array with 6 2TB drives plus a spare. While this works well, I can from the munin graphs at http://munin.karlsbakk.net/munin/karlsbakk.net/smilla.karlsbakk.net/index.html that the WD2001FASS drives (sd[bcfg]) perform some 30% better than the  Hitachi HDS723020BLA642 drives (sd[eh]). The drives are on a mixed set of controllers, so this shouldn't be relevant. Since they all are specified to spin on 7200RPM, I find it wierd that the performance difference shown by the Munin graph is so big.

You've provided zero information about the controllers or the
configuration of the drives.  If the SATA ASIC to which the Black drives
are connected is AHCI and the other is not, then NCQ may account for the
difference in performance.  Or, both may currently be AHCI, but possibly
the Hitachi drives perform better with NCQ disabled.  This would not be
rare.  If you laid partitions on the Hitachi drives and misaligned them,
this could easily cause a 30% deficit.  Etc, etc.

I doubt there is a 30% overall performance difference between these two
drive models.  The Black models are "enthusiast" class drives, and do
have some additional performance features, but not that I'd think would
yield a 30% advantage.

You need to dig deeper into the details.

-- 
Stan

