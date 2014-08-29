From: Andy Smith <andy@strugglers.net>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Fri, 29 Aug 2014 04:02:31 +0000
Message-ID: <20140829040231.GP19874@bitfolk.com>
References: <20140823163110.GE11855@bitfolk.com>
 <20140824130939.461501b4@notabene.brown>
 <20140824143944.GC19874@bitfolk.com>
 <20140825103234.GH11855@bitfolk.com>
 <20140825212614.5be558c9@notabene.brown>
 <20140825113402.GF19874@bitfolk.com>
 <20140829135312.5a6e78bc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140829135312.5a6e78bc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Fri, Aug 29, 2014 at 01:53:12PM +1000, NeilBrown wrote:
> You need to
>   echo 618727392 > /sys/block/md2/md/dev-sda3/size
> and same for the other devices.
> 
> I looks like I need to get mdadm to be more clever when it gets -E2BIG.
> Can you check that the above works?

Unfortunately it seems I cannot change that size:

# echo 618727392 > /sys/block/md2/md/dev-sda3/size
# cat /sys/block/md2/md/dev-sda3/size
309363264

Cheers,
Andy
