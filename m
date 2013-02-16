From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best practice for large storage?
Date: Fri, 15 Feb 2013 23:40:39 -0600
Message-ID: <511F1BD7.2060006@hardwarefreak.com>
References: <9702021.20.1360863570996.JavaMail.root@zimbra> <511D235C.6070409@aeoncomputing.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511D235C.6070409@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/14/2013 11:48 AM, Jeff Johnson wrote:
> Stable enough where it is being used at Lawrence Livermore Nat'l Labs on
> a 55PB Lustre resource.

That's a tad misleading.  LLNL' Sequoia has ZFS striped across three 8+2
hardware RADI6 arrays using 3TB drives.  Lustre is then layered atop
those.  So here ZFS sits atop 72TB raw.  It is not scaling to 55PB.

Something worth noting in this "if they use it so should you" context is
that US gov't computer labs tend to live on the bleeding edge, and have
the budget, resources, and personnel on staff to fix anything, including
rewriting Lustre and ZFS to fit their needs.

The name Donald Becker may be familiar to many here.  He wrote a good
number of the Linux ethernet device drivers while building Beowulf
clusters at NASA.  They bought a bunch of hardware, no Linux drivers
existed, so he wrote them to enable their hardware.  Eventually they
made it into mainline.

The moral of this story should be obvious.

-- 
Stan

