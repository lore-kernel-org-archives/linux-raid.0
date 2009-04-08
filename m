From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: tiny md.h cleanups
Date: Wed, 8 Apr 2009 17:11:56 +1000
Message-ID: <18908.20028.778062.4308@notabene.brown>
References: <20090407161548.GA11724@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christoph Hellwig on Tuesday April 7
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 7, hch@lst.de wrote:
>  - update inclusion guard and make sure it covers the whole file
>  - remove superflous #ifdef CONFIG_BLOCK
>  - make sure all required headers are included so that new users aren't
>    required to include others before

Looks good, thanks.
I'll push to Linus in a few days.

NeilBrown
