From: Andy Smith <andy@strugglers.net>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Fri, 29 Aug 2014 04:42:26 +0000
Message-ID: <20140829044226.GR19874@bitfolk.com>
References: <20140824130939.461501b4@notabene.brown>
 <20140824143944.GC19874@bitfolk.com>
 <20140825103234.GH11855@bitfolk.com>
 <20140825212614.5be558c9@notabene.brown>
 <20140825113402.GF19874@bitfolk.com>
 <20140829135312.5a6e78bc@notabene.brown>
 <20140829040231.GP19874@bitfolk.com>
 <20140829141812.17c35df7@notabene.brown>
 <20140829042618.GQ19874@bitfolk.com>
 <20140829143528.588cf640@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140829143528.588cf640@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Fri, Aug 29, 2014 at 02:35:28PM +1000, NeilBrown wrote:
> On Fri, 29 Aug 2014 04:26:18 +0000 Andy Smith <andy@strugglers.net> wrote:
> > Sorry, still no joy:
> > 
> > # echo 309363696 > /sys/block/md2/md/dev-sda3/size
> > # cat /sys/block/md2/md/dev-sda3/size
> > 309363264
> 
> Try use "/bin/echo" so you get an error message.
> Also try smaller numbers.  Can you write anything larger than what is already
> there?  Increasing by 64 (match the 128 sectors that mdadm wants for
> new_offset) should  be enough.

I can't even increase it by 64 from what it is now:

# /bin/echo 309363328 > /sys/block/md2/md/dev-sda3/size
# cat /sys/block/md2/md/dev-sda3/size
309363264

In fact I can't increase it by 1, and /bin/echo doesn't say why.

Cheers,
Andy
