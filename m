From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: recovering from an aborted reshape op - to ensure at
 least one email gets through!
Date: Mon, 14 Feb 2011 11:00:28 +1100
Message-ID: <20110214110028.5353475d@notabene.brown>
References: <758136.48398.qm@web65107.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <758136.48398.qm@web65107.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Feb 2011 15:10:36 -0800 (PST) Gavin Flower <gavinflower@yahoo.com>
wrote:

> Hi Neil,
> 
> I'll send this now.
> 
> My previous 2 attempts failed.
> 
> I had the first bounce due to HTML, but no errors reported for my second attempt.
> 
> I replied to you blog post.
> 

Yes - vger.kernel.org doesn't like html.
Normal attachments should work - and you should get a bounce-message
if there is something odd.
But this and the following messages did get through.

For those on linux-raid: the background is that a reshape for a RAID6
to change chunksize was interrupted by the admin killing the mdadm
which monitors the reshape.  Then after a reboot the array isn't working 
properly.

When I asked for "mdadm -Evs" I should have asked for an extra 'v' - I keep
forgetting that.
However for now:  what would help is:

 mdadm -S /dev/md1
 mdadm -E /dev/md[abcde]2
 mdadm -Av /dev/md1 /dev/sd[abcde]2
 dmesg | tail -50

capture all of the output and post that.

Thanks,
NeilBrown

