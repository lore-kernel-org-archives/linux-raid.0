From: Neil Brown <neilb@suse.de>
Subject: Re: Growing Linear RAID
Date: Thu, 17 Dec 2009 10:14:35 +1100
Message-ID: <20091217101435.4bc51a69@notabene.brown>
References: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
	<20091210123353.66100b41@notabene.brown>
	<8338BD137FF1B64EB341218BD702985E02C8C165@BLR-EC-MBX03.wipro.com>
	<20091210203008.69cbbe97@notabene.brown>
	<8338BD137FF1B64EB341218BD702985E02C8C9BF@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8338BD137FF1B64EB341218BD702985E02C8C9BF@BLR-EC-MBX03.wipro.com>
Sender: linux-raid-owner@vger.kernel.org
To: senthilkumar.muthukalai@wipro.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Dec 2009 16:32:30 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> Neil,
> 
> I applied the patch but the disk is getting added as a spare.
> Pls guide me here.
>

While I would like to help, it is hard to justify spending much time getting
something working on an old kernel.  Maybe you should try to resolve whatever
issues are keeping you from upgrading to a newer kernel.

At the very least, you would need to provide me with a lot more information
about what if happening.  Exactly what patch you applies, exactly what
command you run, exactly what the output is, exactly what kernel messages you
get, and exactly what the content of "/proc/mdstat" is both before and after.
Even with that I cannot promise anything.

NeilBrown
