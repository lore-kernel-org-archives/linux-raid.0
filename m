From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: [PATCH 03/18] md: occasionally checkpoint drive recovery to
	reduce duplicate effort after a crash
Date: Fri, 13 Feb 2009 10:34:06 -0600
Message-ID: <cccedfc60902130834n3a58fa3dgef976684acab2e11@mail.gmail.com>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	 <20090212031010.23983.74842.stgit@notabene.brown>
	 <49959DC8.1000603@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49959DC8.1000603@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

..
> Since the object of this code is to save time on shutdown and restart, 16
> has little relation to time. I would think that having this update on a time
> basis would more reasonably reflect this. I would like to see a fairly short
> time, say ten minutes, since the cost of a save is low, and ten minutes
> seems like a reasonable lower bound on "worth effort to save" recovery.
>
> As arrays get larger even a 16th of the recovery time can be a pretty long
> time, particularly if the min recovery speed is set fairly low to avoid
> impact on a production server.

I agree. This seems pretty reasonable. How can on protect against time
changes (like my clock just got reset back 21000 seconds type of
problem).

-- 
Jon
