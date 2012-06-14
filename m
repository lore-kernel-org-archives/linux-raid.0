From: "Kurt Schmitt" <kurt_schmitt@gmx.de>
Subject: Re: Check after raid6 failure
Date: Thu, 14 Jun 2012 16:06:13 +0200
Message-ID: <20120614140613.20720@gmx.net>
References: <20120614112955.286290@gmx.net>
 <20120614225239.0dee7594@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120614225239.0dee7594@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

thank you for your very fast answers.

NeilBrown wrote:
> > 3. What other steps can / should I take before continuing raid usage
> (read-write), especially repair on the file system level?
> 
> The file system and RAID can be repaired independently - just go ahead,
> all
> looks good. (unless that 3.2.2 kernel is from Ubuntu - in that case you
> might
> need to be careful... What is the full "uname -a"?).

It is a vanilla kernel that I compiled myself:
Linux fileserver 3.2.2 #4 SMP Wed May 23 14:42:46 CEST 2012 x86_64 Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel GNU/Linux

I can easily upgrade the kernel to 3.2.20 or 3.4.2, if you recommend either of those versions is better suited.

Thanks again,

Kurt
-- 
NEU: FreePhone 3-fach-Flat mit kostenlosem Smartphone!                                  
Jetzt informieren: http://mobile.1und1.de/?ac=OM.PW.PW003K20328T7073a
