From: Neil Brown <neilb@suse.de>
Subject: Re: Kernel panic during resync
Date: Tue, 15 Aug 2006 08:14:04 +1000
Message-ID: <17632.62892.429563.800085@cse.unsw.edu.au>
References: <44DC8153.8010105@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Waldo on Friday August 11
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 11, pwaldo@waldoware.com wrote:
> Hi all,
> 
> I've got a machine with a RAID6 array which hung on me yesterday.  Upon
> reboot, mdadm refused to start the array, since it was degraded and
> dirty.  The array had 7 drives, and one had previously gone bad.  I'm
> running Fedora Core 5.
> 
> I rebooted, using the "md-mod.start_dirty_degraded=1" parameter.
> Everything seemed to be OK--the sync process started and I watched it go
> for about half an hour.  I came back later, and found the machine had a
> kernel panic with the message "Kernel panic - not syncing: Fatal
> exception in interrupt".  Just to make sure, I restarted and tried to
> sync again, but got the same message.
> 
> What might be causing this?  Is there any way to recover?  Thanks in
> advance!

It is very hard to say without more details.
Was there any stack trace?  Any other possibly related messages that
you can report?

And what kernel (exactly) are you using?

NeilBrown
 
