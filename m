From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm create size problem
Date: Tue, 24 May 2005 20:51:36 +1000
Message-ID: <17043.1848.595313.524611@cse.unsw.edu.au>
References: <4277825A.1070405@cc.kuleuven.be>
	<17042.27288.218077.374407@cse.unsw.edu.au>
	<20050524072627.GD31986@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Tuesday May 24
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 24, bluca@comedia.it wrote:
> On Tue, May 24, 2005 at 09:43:20AM +1000, Neil Brown wrote:
> >I guess it is time for a 1.12 ??
> >
> in this case please recheck the ordering issue, since mdadm -Ss does not
> yet work properly.

Thanks for the reminder.
I think I'll just do it as a mutli-pass.
i.e. try to stop everything quietly in any order and as long as
something succeeded and something failed, try again.
Then one last try in non-quite mode to get the right error messages.

NeilBrown
