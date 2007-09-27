From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Help: very slow software RAID 5.
Date: Thu, 27 Sep 2007 18:40:09 -0400
Message-ID: <46FC3149.40904@tmr.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>	<87r6knay66.fsf@informatik.uni-tuebingen.de>	<20070925181618.82F47102162@medulla.enet.sharplabs.com> <87sl521kqh.fsf@informatik.uni-tuebingen.de> <20070925235016.02F6E1023B9@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070925235016.02F6E1023B9@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: brederlo@informatik.uni-tuebingen.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean S. Messing wrote:
> Again, I don't get these speeds. Seq. reads are about
> 170% of the average of my three physical drives if I turn up
> the look-ahead.  Then random access reads drops to slightly less
> than my slowest drive.
>   
As nearly as I can tell, Dean was talking about RAID-10 at that point (I 
also suggested that) which you haven't tried. For small numbers of 
drives, assume the read speed will be (N - 1) * S for large sequential 
read, using RAID-10. Where S is the speed of a single drive. Random read 
depends on so many things I can't begin to quantify them in anything 
less than a full white paper, but for a single thread assume somewhere 
around S and aggregate (N - 1) * S again. Writes depend a lot on system 
tuning, stripe size, stripe_cache_size, chunk size, etc. Fortunately the 
best way to boost write speed is to have lots of memory and let the 
kernel buffer.

Finally, when you create your ext filesystem, think of:
 - ext2 - no journal
 - noatime mounts to avoid journal writes
 - manually make the journal file *large* to spread head motion over drives
 - consider moving journal file to a dedicated device (that old 20GB 
PATA drive?)
 - use the ext3 "stride" tuning stuff (I'm quantifying that in the next 
ten days).

Or just make a RAID-10 "far" array and stop agonizing over this stuff, 
there is no config which is best for everything, you must realize "fast, 
cheap, reliable - pick two" is the design paradigm of RAID, and the more 
you optimize for one usage pattern the more you impact some other.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

