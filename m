From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 20:09:31 +1000
Message-ID: <16969.10587.679662.55065@cse.unsw.edu.au>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
	<6kjnh2-qn4.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Tuesday March 29
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 29, ptb@lab.it.uc3m.es wrote:
> 
> Don't put the journal on the raid device, then - I'm not ever sure why
> people do that!  (they probably have a reason that is good - to them).
> 

Not good advice.  DO put the journal on a raid device.  It is much
safer there.

NeilBrown
