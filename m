From: Josh Litherland <josh@temp123.org>
Subject: Re: Superblock checksum problems
Date: Mon, 04 Sep 2006 16:55:47 -0400
Message-ID: <1157403347.2990.11.camel@localhost>
References: <1157236610.8070.7.camel@localhost>
	 <17659.46517.979409.131348@cse.unsw.edu.au>
	 <1157385612.2990.4.camel@localhost>
Reply-To: josh@temp123.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1157385612.2990.4.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2006-09-04 at 12:00 -0400, Josh Litherland wrote:

> I'll test to see if they actually change values, but I can say for
> certain that they are still invalid checksum, i.e. once I stop the array
> I have to assemble it with -U resync to get it back online. (and it of
> course rebuilds)

Some real strangeness here... So, while the array was up and running
(after mdadm -A -f -U resync ...) I checked the checksums:

       Checksum : 70c30de5 - expected 70c30db5
       Checksum : 70c30df7 - expected 70c30dd7
       Checksum : 70c30e09 - expected 70c30de9
       Checksum : 70c30e1b - expected 70c30deb

Then I unmounted, checked again... here's where things get weird

       Checksum : 70c352e8 - correct
       Checksum : 70c352fa - expected 70c352da
       Checksum : 70c3530c - expected 70c352ec
       Checksum : 70c3531e - correct

Went ahead and issues mdadm -S

       Checksum : 70c352e8 - expected 70c352c8
       Checksum : 70c352fa - expected 70c352da
       Checksum : 70c3530c - expected 70c352ec
       Checksum : 70c3531e - expected 70c352fe

Now utterly perplexed, I went ahead and checked mdadm -E several more
times.  The actual stored checksum value isn't changing, but it's
switching around to saying "expected <something else>" to saying
"correct"... on ALL 4 drives at different times.

Anybody have a clue what's going on here?  How does mdadm (or the
kernel, for that matter) decide what the checksum SHOULD be?  I'll
code-dive to see if I can answer that myself, but if anyones knows,  I'd
appreaciate a pointer.

Thanks!

-- 
Josh Litherland (josh@temp123.org)

