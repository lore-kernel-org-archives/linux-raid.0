From: Neil Brown <neilb@suse.de>
Subject: Re: SET_BITMAP_FILE assembling raid1
Date: Fri, 25 Sep 2009 17:37:17 +1000
Message-ID: <19132.29485.603731.446483@notabene.brown>
References: <20090917160718.15831qsk0zd6k2e8@webmail.ualberta.ca>
	<19123.11528.751595.835367@notabene.brown>
	<20090918113544.11084l0ma4v10u0w@webmail.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from aristizb@ualberta.ca on Friday September 18
Sender: linux-raid-owner@vger.kernel.org
To: aristizb@ualberta.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 18, aristizb@ualberta.ca wrote:
> Hi Neil,
> 
> That is exactly the message I get in the kernel logs.
> 
> I tried ten times to assemble the array (waiting 2 seconds in between)  
> with no luck, but after 2-3 minutes it worked.
> 

That is very strange.
That error message implies that the file is open by some other
program... maybe you have a file browser (Konqueror? nautilus?) open
on /tmp and when the bitmap file changes it opens it to have a look
inside to produce a thumbnail, and that stops md from being able to
use it?  That seems very unlikely though...

Maybe try
  lsof /tmp/md2003bm

to see if anything is using the file.

NeilBrown
