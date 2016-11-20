From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: linux raid wiki - backup files
Date: Sun, 20 Nov 2016 14:48:25 +0000
Message-ID: <5831B7B9.8090008@youngman.org.uk>
References: <583077D0.5070804@youngman.org.uk>
 <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/11/16 00:27, Phil Turmel wrote:
> Yes.  But the new stripes lay on top of the old stripes, unless you move
> the data offset.  Which is why a backup file holds the old stripe just
> in case.  If you can move the offset, you use the lower offset for the
> lower addresses in the array, and the higher offset for the higher
> addresses, on either side of the reshape position.

Okay, understood. So v0.9 and v1.0 always need a backup for a reshape.

But if we have a data offset with v1.2, a reshape will use that space if
it can rather than needing a backup file?

(And changing topic slightly, that space is also used for an internal
bitmap?)

Cheers,
Wol
