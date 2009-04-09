From: Neil Brown <neilb@suse.de>
Subject: Re: Any benefity to write intent bitmaps on Raid1
Date: Thu, 9 Apr 2009 15:59:25 +1000
Message-ID: <18909.36541.447308.778177@notabene.brown>
References: <45635.60.234.49.2.1239236645.squirrel@webmail.stevencherie.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steven Ellis on Thursday April 9
Sender: linux-raid-owner@vger.kernel.org
To: Steven Ellis <steven@openmedia.co.nz>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday April 9, steven@openmedia.co.nz wrote:
> Given I have a pair of 1TB drives Raid1 I'd prefer to reduce any recovery
> sync time. Would an internal bitmap help dramatically, and are there any
> other benefits.

Bryan answered some of this but...

 - if your machine crashes, then resync will be much faster if you
   have a bitmap.
 - If one drive becomes disconnected, and then can be reconnected,
   recovery will be much faster.
 - if one drive fails and has to be replaced, a bitmap makes no
   difference(*).
 - there might be performance hit - it is very dependant on your
   workload.
 - You can add or remove a bitmap at any time, so you can try to
   measure the impact on your particular workload fairly easily.


(*) I've been wondering about adding another bitmap which would record
which sections of the array have valid data.  Initially nothing would
be valid and so wouldn't need recovery.  Every time we write to a new
section we add that section to the 'valid' sections and make sure that
section is in-sync.
When a device was replaced, we would only need to recover the parts of
the array that are known to be invalid.
As filesystem start using the new "invalidate" command for block
devices, we could clear bits for sections that the filesystem says are
not needed any more...
But currently it is just a vague idea.

NeilBrown
