From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 5] md: Split disks array out of raid5 conf structure so it is easier to grow.
Date: Thu, 19 Jan 2006 11:26:18 +1100
Message-ID: <17358.56490.127364.327688@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<1060117065614.27831@suse.de>
	<17357.271.619918.45917@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Stoffel on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Tuesday January 17, john@stoffel.org wrote:
> >>>>> "NeilBrown" == NeilBrown  <neilb@suse.de> writes:
> 
> NeilBrown> Previously the array of disk information was included in
> NeilBrown> the raid5 'conf' structure which was allocated to an
> NeilBrown> appropriate size.  This makes it awkward to change the size
> NeilBrown> of that array.  So we split it off into a separate
> NeilBrown> kmalloced array which will require a little extra indexing,
> NeilBrown> but is much easier to grow.
> 
> Neil,
> 
> Instead of setting mddev->private = NULL, should you be doing a kfree
> on it as well when you are in an abort state?

The only times I set 
  mddev->private = NULL
it is immediately after
   kfree(conf)
and as conf is the thing that is assigned to mddev->private, this
should be doing exactly what you suggest.

Does that make sense?

NeilBrown
