From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed raid5
Date: Mon, 31 Oct 2016 12:09:58 +0100
Message-ID: <20161031110957.GA4081@metamorpher.de>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
 <af2bf92d-c944-2269-1925-50baa44755a2@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <af2bf92d-c944-2269-1925-50baa44755a2@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 31, 2016 at 10:44:38AM +0000, Alexander Shenkin wrote:
> or are sizes of 3TB slightly different enough for that to cause me 
> headaches when adding it back into the array?

This is usually not much to worry about, worst case you tell mdadm to 
shrink the size a little. But I don't see how it applies in your case. 
The partition you're interested in is not 3TB, and there is a swap 
partition you could skip if there's really no other way...

You can ddrescue partitions too, doesn't have to be the whole disk.

You posted parted output earlier, parted uses stupid unit by default 
so I usually prefer 'parted /dev/disk unit s print free'.

Regards
Andreas Klauer
