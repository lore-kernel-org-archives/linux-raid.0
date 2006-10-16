From: Neil Brown <neilb@suse.de>
Subject: RE: new features time-line
Date: Mon, 16 Oct 2006 15:37:39 +1000
Message-ID: <17715.6819.120507.726768@cse.unsw.edu.au>
References: <45300FC5.80806@h3c.com>
	<000b01c6ef25$c498bb50$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan on Friday October 13
Sender: linux-raid-owner@vger.kernel.org
To: Dan <dan@korstad.net>
Cc: 'Mike Hardy' <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 13, dan@korstad.net wrote:
> Good to hear.  
> 
> I think when I first built my RAID (a few years ago) I did some research on
> this;
> http://www.google.com/search?hl=en&q=bad+block+replacement+capabilities+mdad
> m
> 
> And found stories where bit errors were an issue.
> http://www.ogre.com/tiki-read_article.php?articleId=7
> 
> After your email, I went out and researched it again.  Eleven months ago a
> patch to address this was submitted for RAID5, I would assume RAID6
> benefited from it too? 

Yes.  All appropriate raid level support auto-overwrite of read
errors.

NeilBrown
