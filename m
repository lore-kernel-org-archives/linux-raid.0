From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --grow failed
Date: Sat, 17 Feb 2007 19:40:17 +1100
Message-ID: <17878.49009.771973.884472@notabene.brown>
References: <20070217030514.M74974@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc Marais on Saturday February 17
Sender: linux-raid-owner@vger.kernel.org
To: Marc Marais <marcm@liquid-nexus.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday February 17, marcm@liquid-nexus.net wrote:
> 
> Is my array destroyed? Seeing as the sda disk wasn't completely synced I'm 
> wonder how it was using to resync the array when sdc went offline. I've got 
> a bad feeling about this :|

I can understand your bad feeling...
What happened there shouldn't happen, but obviously it did.  There is
evidence that all is not lost but obviously I cannot be sure yet.

Can you "fsck -n" the array?  does the data still seem to be intact?

Can you report exactly what version of Linux kernel, and of mdadm you
are using, and give the output of "mdadm -E" on each drive.

I'll try to work out what happened and how to go forward, but am
unlikely to get back to you for 24-48 hours (I have a busy weekend:-).

NeilBrown
