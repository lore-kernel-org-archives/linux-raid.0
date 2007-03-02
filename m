From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] md: Fix for raid6 reshape.
Date: Thu, 1 Mar 2007 22:36:19 -0800
Message-ID: <20070301223619.d9957521.akpm@linux-foundation.org>
References: <20070302155626.19014.patches@notabene>
	<1070302045655.19069@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1070302045655.19069@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Mar 2007 15:56:55 +1100 NeilBrown <neilb@suse.de> wrote:

> -	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
> +	conf->expand_progress = (sector_nr + i) * new_data_disks);

ahem.
