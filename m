From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed raid5
Date: Wed, 16 Nov 2016 14:59:38 +0100
Message-ID: <20161116135938.GA4658@metamorpher.de>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
 <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
 <20161116111407.GA3348@metamorpher.de>
 <f82a86e0-e734-5b58-4796-63fe1923d49d@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f82a86e0-e734-5b58-4796-63fe1923d49d@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 16, 2016 at 01:27:55PM +0000, Alexander Shenkin wrote:
> Does that mean that ddrescue has copied the 512 partition tables 
> to my 4k drive, and hence I just need to fix the partition table 
> on the new 4k drive?

Just so.

And the missing 4096 bytes don't matter, you had enough unpartitioned space.
It doesn't affect your data at all.

As for the 128K I counted all non+, if it's only 64K then even better.

Regards
Andreas Klauer
