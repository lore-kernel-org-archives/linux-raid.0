From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid1 info (not active degraded raid)
Date: Wed, 01 Jun 2011 13:34:46 -0400
Message-ID: <4DE67836.1060103@turmel.org>
References: <201106011832.51688.raid2@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201106011832.51688.raid2@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/01/2011 12:32 PM, Pol Hallen wrote:
> Hi folks :-)
> 
> I build a raid1 with mdadm. For purpose test I disconnected a disk and raid1 
> runs perfectly.
> 
> After reboot /dev/md1 (raid1) doesn't appear by cat /proc/mdstat
> 
> (I have also a raid6 on /dev/md0)
> 
> mdadm -E /dev/sdh (a disk of raid1) show me correct raid
> 
> How I start this raid?

Look at kernel parameter "md-mod.start_dirty_degraded=1"

> raid6 works so mdadm runs.
> 
> thanks and sorry for my bad english :-@

Your english is fine.  Your return address is not so nice.  I'm somewhat surprised it got through my spam filters.  It won't again.

HTH,

Phil
