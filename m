From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md array starts/stops.
Date: Tue, 31 Oct 2006 13:16:15 -0800
Message-ID: <20061031211615.GC21597@suse.de>
References: <20061031164814.4884.patches@notabene> <1061031060046.5034@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1061031060046.5034@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 31, 2006 at 05:00:46PM +1100, NeilBrown wrote:
> 
> This allows udev to do something intelligent when an
> array becomes available.
> 
> cc: gregkh@suse.de
> Signed-off-by: Neil Brown <neilb@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
