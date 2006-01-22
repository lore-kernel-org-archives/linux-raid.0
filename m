From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 5] md: Split disks array out of raid5 conf structure so it is easier to grow.
Date: Mon, 23 Jan 2006 09:57:05 +1100
Message-ID: <17364.3521.662774.431030@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<1060117065614.27831@suse.de>
	<17357.271.619918.45917@smtp.charter.net>
	<17358.56490.127364.327688@cse.unsw.edu.au>
	<17361.44149.200493.916170@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Stoffel on Friday January 20
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Friday January 20, john@stoffel.org wrote:
> Though now that I look at it, don't we have a circular reference
> here?  Let me quote the code section, which starts of with where I was
> confused: 
..
> 
> Now we seem to end up with:
> 
> 	mddev->private = conf;
> 	conf->mddev = mddev;
> 

This is simply to related structures each holding a reference to the
other.  It's like the child pointing to the parent, and the parent
pointing to the child, which you get all the time.

NeilBrown
