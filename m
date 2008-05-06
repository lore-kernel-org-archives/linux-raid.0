From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Tue, 6 May 2008 16:53:58 +1000
Message-ID: <18464.134.236488.251879@notabene.brown>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Wednesday April 2
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Wednesday April 2, snitzer@gmail.com wrote:
> resync via bitmap if faulty's events+1 == bitmap's events_cleared
> 
> For more background please see:
> http://marc.info/?l=linux-raid&m=120703208715865&w=2
> 
> Without this change validate_super() will prevent the previously faulty
> member from recovering via bitmap, e.g.:

I can't help thinking that you are misinterpreting something.  I don't
think there is a clean->dirty transition happening here.
You could confirm this by using --examine on both devices after the
messy shutdown and before re-assembling the array.

Even allowing for that possible confusion, I cannot quite see what is
going on.
It is fairly clear from the event counts that the NBD device is marked
clean, but if this is happening at array-shutdown time, I cannot see
why md would try to write to the NBD device and thereby detect an
error...

Do you have an internal bitmap or a bitmap in an external file?

In general, I would not like to make decisions based on the
oddness/evenness of the event counter.  I consider that to be an
internal implementation detail.  I am happy to make decisions based on
a difference-of-1.  I need to understand the big picture first though.

NeilBrown
