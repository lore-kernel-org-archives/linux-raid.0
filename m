From: linux@horizon.com
Subject: Re: Interesting RAID checking observations
Date: 21 Sep 2006 14:48:59 -0400
Message-ID: <20060921184859.13314.qmail@science.horizon.com>
References: <20060921065808.19682.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060921065808.19682.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com, neilb@suse.de
List-Id: linux-raid.ids

> But anyway, it's better, so thank you!  I haven't rebooted the celeron
> I hung for the duration of a RAID-1 check, so I haven't checked that with
> 2.6.18 yet.

Followup: 2.6.18 installed and tested; no change.  The machine still
"goes away" for the duration if three RAID-1 checks are run in parallel,
and comes back to life only when the first one finishes.
