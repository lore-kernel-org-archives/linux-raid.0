From: Tyler <pml@dtbb.net>
Subject: Re: RAID6 starts before RAID0 component - how to force the order?
Date: Fri, 05 Aug 2005 22:40:46 -0700
Message-ID: <42F44D5E.7060201@dtbb.net>
References: <20050806045043.GA31307@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050806045043.GA31307@pog.tecnopolis.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Trevor Cordes <trevor@tecnopolis.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I only have a suggestion, not a definitive answer by any means.. but you 
may want to try the latest 2.6.13-rc3-mmX (or maybe rc4-mmX), I believe 
it has some changes in it, regarding the scanning and initialization of 
multi-level arrays.  I could be wrong though, but worth a shot in the 
day and age of 10 minute or less compiles :)

Tyler.

Trevor Cordes wrote:

>I'll keep this short and to the point and I'm hoping for a quick simple 
>high-level answer from the gurus.  I don't need hand holding, so please 
>take a quick look!
>
>I have a new RAID6 array.  A component of that array is a RAID0 sub-array.  
>mdadm creates and rebuilds this multilevel array just fine.  Then I 
>reboot.  Boot log shows RAID6 detected first, _THEN_ RAID0.  Thus RAID6 is 
>degraded without its RAID0 component.
>
>The RAID0 array is fine/clean.  It's just a boot order problem I'm sure.
>
>How do I set/force the order that arrays are started at boot time?  When 
>doing multi-level arrays, you would think either a) you can force it or b) 
>it would be "smart" about it.
>
>FC3 kernel-2.6.12-1.1372_FC3
>using mdadm
>no raidtab
>
>Thanks!
>
>PS #1: if this is a mailing list, please CC my email.
>PS #2: I did google searches for 2 hours and there is ZILCH on this topic
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
