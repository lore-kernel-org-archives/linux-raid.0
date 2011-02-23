From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: failing a drive while RAID5 is initializing
Date: Wed, 23 Feb 2011 17:08:48 -0500
Message-ID: <4D658570.2040601@cdf.toronto.edu>
References: <4D6533D2.3020600@cdf.toronto.edu> <20110223163354.GA25777@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223163354.GA25777@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the clear answer. I am glad I didn't uncover a bug with 
something so basic.

> Some of the features on Neil's current roadmap should allow for "lazy
> initialisation" where the recovery data is added only as the drive is
> written to, which should mean the array is available immediately but
> still retains full recoverability.

I was thinking that this is how things work now, but now that you 
mentioned it, the man-page does say that the array is degraded to begin 
with and is rebuilding onto the last device during initialization.

To make this lazy initialization possible, one would have to have a 
bitmap of "dirtied" chunks, though, right?

Cheers,
Iordan
