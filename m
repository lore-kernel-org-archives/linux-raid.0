From: Neil Brown <neilb@suse.de>
Subject: Re: RAID4 and RAID5 Code
Date: Fri, 15 May 2009 11:23:44 +1000
Message-ID: <18956.50208.233428.183074@notabene.brown>
References: <37d33d830905140957q6e180d89v4cd4a21d23471481@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Thursday May 14
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday May 14, sandeepksinha@gmail.com wrote:
> Hi all,
> 
> Looks like we have the same code for RAID 4 and RAID 5, I could see
> the same make_request for both.
> 
> Can someone point me in the code, where exactly we differentiate
> between these two. i.e updating checksum block, etc.

Look for "conf->level" in e.g. raid5_compute_sector.

NeilBrown
