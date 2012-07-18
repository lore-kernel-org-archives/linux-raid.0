From: Brian Downing <bdowning@lavos.net>
Subject: Re: v3.5 regression in IMSM support
Date: Tue, 17 Jul 2012 21:20:50 -0500
Message-ID: <20120718022050.GG23042@glaurung.lavos.net>
References: <20120717090526.GF23042@glaurung.lavos.net>
 <20120718103458.70046aaf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120718103458.70046aaf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 18, 2012 at 10:34:58AM +1000, NeilBrown wrote:
> Thank you so much for a very thorough bug report!!
> 
> Fix is below - please test and confirm that it fixes your symptoms.

I applied this to Linus's master as of today and it appears to restore
the earlier working behavior for my system, including incremental assembly
and a correct-looking mdstat:

    :; uname -r
    3.5.0-rc7-ARCH-00082-g04f15c7
    :; cat /proc/mdstat 
    Personalities : [raid0] 
    md126 : active raid0 sda[1] sdb[0]
          625137664 blocks super external:/md127/0 128k chunks
      
    md127 : inactive sdb[1](S) sda[0](S)
          4520 blocks super external:imsm

Thank you very much for the quick fix!

Tested-by: Brian Downing <bdowning@lavos.net>

-bcd
