From: Josh Litherland <josh@temp123.org>
Subject: Re: Superblock checksum problems
Date: Mon, 04 Sep 2006 12:00:12 -0400
Message-ID: <1157385612.2990.4.camel@localhost>
References: <1157236610.8070.7.camel@localhost>
	 <17659.46517.979409.131348@cse.unsw.edu.au>
Reply-To: josh@temp123.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17659.46517.979409.131348@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2006-09-04 at 15:12 +1000, Neil Brown wrote:

> It this repeatable?

100% repeatable.

> Does the checksum stay wrong? 

Yes, once they have changed to the bad value, they don't move again that
I've seen (done several trials over the past few days).

> If you stop the array and run 'mdadm -E' on the drives, what values do
> they have now.

I'll test to see if they actually change values, but I can say for
certain that they are still invalid checksum, i.e. once I stop the array
I have to assemble it with -U resync to get it back online. (and it of
course rebuilds)

I'm starting to suspect the card's BIOS; it might either be bad or be
some version which interacts strangely with the sata_sil driver.  I am
going to hunt for a flash update for it soon.

Thanks for the reply!

-- 
Josh Litherland (josh@temp123.org)

