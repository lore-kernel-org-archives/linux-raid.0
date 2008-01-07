From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Tue, 8 Jan 2008 09:47:07 +1100
Message-ID: <18306.44011.512618.609434@notabene.brown>
References: <477FAAAC.2090107@fayettedigital.com>
	<18305.22361.482483.331552@notabene.brown>
	<47823B46.6010105@fayettedigital.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim on Monday January 7
Sender: linux-raid-owner@vger.kernel.org
To: jim@fayettedigital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 7, jim@fayettedigital.com wrote:
> Problem is not raid, or at least not obviously raid related.  The 
> problem is that the whole disk, /dev/hdb is unavailable. 

Maybe check /sys/block/hdb/holders ?  lsof /dev/hdb ?

good luck :-)

NeilBrown
