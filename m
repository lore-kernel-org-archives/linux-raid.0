From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 always resyncs at boot???
Date: Fri, 28 Nov 2003 10:14:02 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16326.34106.78894.57151@notabene.cse.unsw.edu.au>
References: <hp0nmt.3pm23q@mail.drtebi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from drtebi@drtebi.com on Thursday November 27
To: drtebi@drtebi.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 27, drtebi@drtebi.com wrote:
> 
> Everything like reading and writing to the md0 works just fine, and still does
> now, except the resync starts again at every boot! 
> What is wrong, or what is it that I don't understand? Is it supposed to resync
> at every boot?

No, it is not suppose to resync at every boot, providing that it shuts
down properly.
How do you shut down your machine?  If you just turn the power off,
you would get a resync at every boot.  If you shutdown gracefully with
"/sbin/halt" or similar, you shouldn't.

So: how do you shut down, and do you get any interesting kernel
messages on the console during shutdown?

NeilBrown
