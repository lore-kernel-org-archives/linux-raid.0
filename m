From: Neil Brown <neilb@suse.de>
Subject: Re: addingdrive to raid 1
Date: Mon, 26 Mar 2007 21:17:34 +1000
Message-ID: <17927.43982.475535.846718@notabene.brown>
References: <46061A61.7030806@stanford.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert Stanford on Sunday March 25
Sender: linux-raid-owner@vger.kernel.org
To: Robert Stanford <rob@stanford.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday March 25, rob@stanford.com.au wrote:
> Hi All, Long time Linux software raid user, first real problem.
> 
> I built md2 with 1 missing drive and am now trying to add a drive (hda4)
> 
> The partition that is hda4 was previously part of another  raid array 
> md1 that no longer exists.
> 
> I have zeroed the superblock in hda4, however when I try to add it it 
> sync's instantly, no rebuild.
> 
> The original raid array md1 is several years old and was built with the 
> old raidtools package.
> 
> I even ran
> dd if=/dev/zero of=/dev/hda4
> just to be sure that nothing was left on the partition from the previous 
> raid setup and still no joy.
> 
> Any help would be appreciated

You didn't say what kernel version.
I'd guess 2.6.18.  You want 2.6.18.2 or later to fix this problem.

NeilBrown
