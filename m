From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 stuck in degraded, inactive and dirty mode
Date: Wed, 9 Jan 2008 17:52:57 +1100
Message-ID: <18308.28489.479077.86397@notabene.brown>
References: <20080109055544.GR3940@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from CaT on Wednesday January 9
Sender: linux-raid-owner@vger.kernel.org
To: CaT <cat@zip.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 9, cat@zip.com.au wrote:
> 
> I'd provide data dumps of --examine and friends but I'm in a situation
> where transferring the data would be a right pain. I'll do it if need
> be, though.
> 
> So, what can I do? 

Well, providing the output of "--examine" would help a lot.

But I suspect that "--assemble --force" would do the right thing.
Without more details, it is hard to say for sure.

NeilBrown
