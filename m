From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Questions answered by Neil Brown
Date: Tue, 25 Feb 2003 14:10:23 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15962.56991.813214.12276@notabene.cse.unsw.edu.au>
References: <200302242015.h1OKFhA04699@oboe.it.uc3m.es>
	<3E5A9598.3AED4AE5@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Monday February 24
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 24, Paul.Clements@SteelEye.com wrote:
>  
> So I think this means that we really need to duplicate the buffer memory
> (bh->b_page, bh->b_data) and point the mirror I/Os to the duplicated
> buffer, so we can allow the original (master_bh) to be freed before all
> the I/Os complete. We then free the duplicate when the last mirror I/O
> completes, right?


Yes, that is right.

NeilBrown
