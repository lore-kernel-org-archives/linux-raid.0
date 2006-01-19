From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 11:22:31 +1100
Message-ID: <17358.56263.806371.53617@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43CCA80B.4020603@tls.msk.ru>
	<20060117095019.GA27262@localhost.localdomain>
	<43CCD453.9070900@tls.msk.ru>
	<20060117160829.GA16606@lug.udel.edu>
	<43CD3388.9050107@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ross Vandegrift <ross@lug.udel.edu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 17, mjt@tls.msk.ru wrote:
> 
> As a sort of conclusion.
> 
> There are several features that can be implemented in linux softraid
> code to make it real Raid, with data safety goal.  One example is to
> be able to replace a "to-be-failed" drive (think SMART failure
> predictions for example) without removing it from the array with a
> (hot)spare (or just a replacement) -- by adding the new drive to the
> array *first*, and removing the to-be-replaced one only after new is
> fully synced.  Another example is to implement some NVRAM-like storage
> for metadata (this will require the necessary hardware as well, like
> eg a flash card -- I dunno how safe it can be).  And so on.

proactive replacement before complete failure is a good idea and is
(just recently) on my todo list.  It shouldn't be too hard.

> 
> The current MD code is "almost here", almost real.  It still has some
> (maybe minor) problems, it still lacks some (again maybe minor) features
> wrt data safety.  Ie, it still can fail, but it's almost here.

concrete suggestions are always welcome (though sometimes you might
have to put some effort into convincing me...)

> 
> While current development is going to implement some new and non-trivial
> features which are of little use in real life.  Face it: yes it's good
> when you're able to reshape your array online keeping servicing your
> users, but i'd go for even 12 hours downtime if i know my data is safe,
> instead of unknown downtime after I realize the reshape failed for some
> reason and I dont have my data anymore.  And yes it's very rarely used
> (which adds to the problem - rarely used code paths with bugs with stays
> unfound for alot of time, and bite you at a very unexpected moment, when
> you think it's all ok...)

If you look at the amount of code in the 'reshape raid5' patch you
will notice that it isn't really very much.  It reuses a lot of the
infrastructure that is already present in md/raid5.  So a reshape
actually uses a lot of code that is used very often.

Compare this to an offline solution (raidreconfig) where all the code
is only used occasionally.  You could argue that the online version
has more code safety than the offline version....

NeilBrown
