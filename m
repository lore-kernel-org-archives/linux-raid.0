From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: best common practice in case of degraded array with read
 errors
Date: Tue, 17 Nov 2009 17:44:12 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0911171736210.14550@uplift.swm.pp.se>
References: <alpine.DEB.1.10.0911162224530.14550@uplift.swm.pp.se> <20091116220722.GC14699@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.0911162309000.14550@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0911162309000.14550@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 16 Nov 2009, Mikael Abrahamsson wrote:

Hi,

just wanted to report success on my dd_rescue (it actually didn't get any 
errors while dd:ing to the new drive (which is weird since SMART reports 
the drive to have 3 "pending sectors")).

Anyhow, I got the array working again with

"mdadm --assemble --force --uuid=<UUID> /dev/md0"

(it reset the event counter on the previously kicked drive)

and it's now rebuilding after --add:ing another new drive.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
