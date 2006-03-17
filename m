From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 005 of 13] md: Allow stripes to be expanded in
 preparation for expanding an array.
Date: Thu, 16 Mar 2006 21:53:23 -0800
Message-ID: <20060316215323.0ae5c7bb.akpm@osdl.org>
References: <20060317154017.15880.patches@notabene>
	<1060317044745.16072@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060317044745.16072@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +		wait_event_lock_irq(conf->wait_for_stripe,
>  +				    !list_empty(&conf->inactive_list),
>  +				    conf->device_lock,
>  +				    unplug_slaves(conf->mddev);
>  +			);

Boy, that's an ugly-looking thing, isn't it?

__wait_event_lock_irq() already puts a semicolon after `cmd' so I think the
one here isn't needed, which would make it a bit less of a surprise to look
at.

