From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 2/2] Detail: deterministic ordering in --brief --verbose
Date: Thu, 20 Jun 2013 22:26:23 +0200
Message-ID: <51C3656F.4010107@arcor.de>
References: <1371759665-5625-1-git-send-email-mwilck@arcor.de> <1371759665-5625-2-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1371759665-5625-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

On 06/20/2013 10:21 PM, mwilck@arcor.de wrote:

> (I confess: I use a modified "test" script that always runs
> "mdadm --verbose" rather than "mdadm --quiet", otherwise this
> wouldn't happen in 10ddf-create).

... and this test failed after applying commit b3908491,
that's the background for these two patches.

The standard test case that runs mdadm --quiet would not fail. But I
still think these patches are useful. They simplify at least my testing
& debugging.

Regards
Martin
