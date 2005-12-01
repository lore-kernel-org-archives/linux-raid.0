From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 006 of 14] Make /proc/mdstat pollable.
Date: Thu, 1 Dec 2005 14:39:28 -0800
Message-ID: <20051201143928.0c1b63d7.akpm@osdl.org>
References: <20051201141508.29384.patches@notabene>
	<1051201032316.29617@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051201032316.29617@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>  

static scope?
