From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Mon, 7 Jan 2008 09:28:58 +1100
Message-ID: <18305.22058.609143.869202@notabene.brown>
References: <477FAAAC.2090107@fayettedigital.com>
	<20080105210002.t5syxhjahwocks4g@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nagilum on Saturday January 5
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: jim@fayettedigital.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 5, nagilum@nagilum.org wrote:
> 
> Since /dev/hdb5 has been part of this array before you should use  
> --re-add instead of --add.
> Kind regards,
> Alex.

That is not correct.

--re-add is only needed for arrays without metadata, for which you use
"--build" to start them.

NeilBrown
