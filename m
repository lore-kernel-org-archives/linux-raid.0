From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Date: Wed, 21 Feb 2007 14:48:06 -0800
Message-ID: <20070221144806.e6eed85c.akpm@linux-foundation.org>
References: <20070220172544.15678.patches@notabene>
	<1070220063516.16208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1070220063516.16208@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 20 Feb 2007 17:35:16 +1100
NeilBrown <neilb@suse.de> wrote:

> +		for (i = conf->raid_disks ; i-- ;  ) {

That statement should be dragged out, shot, stomped on then ceremonially
incinerated.

What's wrong with doing

	for (i = 0; i < conf->raid_disks; i++) {

in a manner which can be understood without alcoholic fortification?

ho hum.
