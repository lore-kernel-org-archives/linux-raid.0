From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: monitor event argument passing
Date: Mon, 3 Apr 2006 10:16:14 +1000
Message-ID: <17456.26958.388668.339215@cse.unsw.edu.au>
References: <442D7864.9020901@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday March 31
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 31, paul.clements@steeleye.com wrote:
> 
> I've been looking at the mdadm monitor, and thought it might be useful 
> if it allowed extra context information (in the form of command line 
> arguments) to be sent to the event program, so instead of just:
> 
> # mdadm -F /dev/md0 -p "md_event"
> 
> you could do something like:
> 
> # mdadm -F /dev/md0 -p "md_event -i <some_info>"
> 
> And the "-i <some_info>" will be passed on the command line to the event 
> program. Of course you can usually figure out what the extra context 
> should be in the event program itself, but it may take more work.

I would recommend the use of environment variables for this:

  md_event_context=<some_info> mdadm -F /dev/md0 -p md_event

It is true that this cannot be specified in mdadm.conf, but I don't
think you really need it at all in that context.  The <some_info> can
be explicit in the script rather than in mdadm.conf.

Does that work for you?

NeilBrown
