From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] secure write for RAID1
Date: Wed, 27 Apr 2005 13:24:36 +1000
Message-ID: <17007.1524.476174.515614@cse.unsw.edu.au>
References: <1toqj2-sjd.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Saturday April 23
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 23, ptb@lab.it.uc3m.es wrote:
> This patch (completely untested of course - what, me?) makes RAID1 write
> to all components of a raid-1 array, else return error to the write
> attempt, when one component cannot be written.

I don't understand why or when you would want this.

This wouldn't just return an error to the application if the write
wasn't completely safe.  It would cause the filesystem to switch to
read-only very quickly and make your machine un-usable.  Is that
really what you want??

NeilBrown
