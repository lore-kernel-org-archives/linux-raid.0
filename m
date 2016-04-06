From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] badblocks: fix wrong return value when badblocks are
 disabled
Date: Wed, 06 Apr 2016 11:26:13 +0200
Message-ID: <c59033805128cba9151ccf328dd7638b@suse.de>
References: <1459861174-9238-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1459861174-9238-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, vishal.l.verma@intel.com, linux-raid@vger.kernel.org, linux-block-owner@vger.kernel.org
List-Id: linux-raid.ids

On 2016-04-05 14:59, Artur Paszkiewicz wrote:
> The return value of md_set_badblocks() was inverted when the code was
> taken out of md, but the case when badblocks are disabled was left
> unchanged. This causes silent ignoring of I/O errors and other
> unpredictable behavior on md arrays that do not support badblocks (any
> array not using v1.x metadata).
> 
> Fixes: 9e0e252a048b ("badblocks: Add core badblock management code")
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

