From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 20:25:55 +1100
Message-ID: <17264.28451.765275.441918@cse.unsw.edu.au>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk>
	<17263.57266.902113.362087@cse.unsw.edu.au>
	<5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk>
	<17263.59743.163989.959271@cse.unsw.edu.au>
	<D8682F09-5A4D-4356-8FA6-825880F93AE4@fnuck.dk>
	<17263.61561.506974.198576@cse.unsw.edu.au>
	<4E521E9D-FDA7-4F7B-9E30-6DE568050214@fnuck.dk>
	<17264.1440.176313.287686@cse.unsw.edu.au>
	<B8B08849-784B-48A4-B49B-4F9FBEE2BCE9@fnuck.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Troels Bang Jensen on Tuesday November 8
Sender: linux-raid-owner@vger.kernel.org
To: Troels Bang Jensen <marvin@fnuck.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 8, marvin@fnuck.dk wrote:
> 
> Ah. In the file etc/script I found the line
> 
> mdadm -A /dev/md1 -R -u 4b22b17d:06048bd3:ecec156c:31fabbaf /dev/ 
> hda3 /dev/hdg2
> 
> -wouldn't the best thing just be to add /dev/hdc3 there?
> 

Yes, however a cramfs filesystem is write-only.  "Just adding it here"
is easier said than done.  "mkinitrd" should try to create a brand new
cramfs filesystem for you, and might get it right.

> 
> However, you've been incredibly helpful. You've solved my problem,  
> thanks!

My pleasure.  You've helped me learn something about they ways people
(i.e. Debian mkinitrd in this case) misused my creations (mdadm), and
that should help me to make them better - or at least better
documented - in future.

All the best,

NeilBrown
