From: Neil Brown <neilb@suse.de>
Subject: Re: teeny but significant typo in latest mdadm ANNOUNCE
Date: Mon, 8 Feb 2010 16:37:25 +1100
Message-ID: <20100208163725.1572d27c@notabene.brown>
References: <20100201145508.R6679@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100201145508.R6679@cisco.com>
Sender: linux-raid-owner@vger.kernel.org
To: LJ Wobker <lwobker@cisco.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 Feb 2010 14:55:08 -0500
LJ Wobker <lwobker@cisco.com> wrote:

> I'm looking at:
> 
> http://www.kernel.org/pub/linux/utils/raid/mdadm/ANNOUNCE
> 
> which says the following:
> 
>   - The default metadata is not v1.1.  This metadata is stored at the
>     start of the device so is safer in many ways but could interfere with
>     boot loaded.  The old default (0.90) is still available and fully
>     supported.
> 
> 
> I'm about 99.5% sure that this should read 
> 	"The default metadata is *now* v1.1"  
> rather than 
> 	"The default metadata is *not* v1.1"
> 
> ordinarily I'd think this completely trollish behavior, but since the
> 1-letter typo changes what the sentence means, I figured I'd bring it up.
> ;-)
> 
> --lj

Thanks.  I've just fixed in on kernel.org

NeilBrown


> 
> -------------------------------------------------------------------------
> Lawrence J. Wobker   "Highly trained network monkey"    lwobker@cisco.com
> CCIE #5020                  Technical Marketing Engineer, ASR 9000 Series
> -------------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

