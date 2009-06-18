From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] Intel metadata and mapfile fixes for mdadm-3.0.1
Date: Thu, 18 Jun 2009 15:57:37 +1000
Message-ID: <19001.55121.865711.172936@notabene.brown>
References: <1245203203.3668.13.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday June 16
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday June 16, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> The following changes since commit 6e92d480f765dc22a5abaa5658ad603353648c1c:
>   NeilBrown (1):
>         Release mdadm-3.0
> 
> are available in the git repository at:
> 
>   git://github.com/djbw/mdadm.git master
> 

Thanks.  However.....

> Dan Williams (6):
>       fix RebuildMap() to retrieve 'subarray' info

This hides two totally different changes in the one patch, which is
never a good idea.
I'm not at all convinced about the 

    For imsm we need an additional fixup to force local naming otherwise
    RebuildMap() will always choose foreign names.
    
bit.  Maybe if you could explain that.


>       teach imsm and ddf what st->subarray means at load_super time
>       fix examine_brief segfault
>       imsm: fixup examine_brief to be more descriptive in the container only case

Those seem OK.

>       fixup map file after Create

This one bothers me too.  If there is a need to update the mapfile,
then we should perform the required update, e.g. with map_update.
What exactly is needed here?


>       imsm: fix activate_spare off-by-one

I would have fixed this by simply changing the '<' to '<=', but your
fix is OK, and esize can certainly go.

So for now I haven't pulled any of this.

Thanks,
NeilBrown
