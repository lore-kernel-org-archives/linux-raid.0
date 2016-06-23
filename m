From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: fix wrong value in md.txt
Date: Thu, 23 Jun 2016 08:08:54 -0600
Message-ID: <20160623080854.08bf0d4f@lwn.net>
References: <2b0cf4c2.21fa.1555c03d3e9.Coremail.kernelpatch@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2b0cf4c2.21fa.1555c03d3e9.Coremail.kernelpatch@126.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tiezhu Yang <kernelpatch@126.com>
Cc: shli@kernel.org, linux-doc@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Jun 2016 09:40:02 +0800 (CST)
"Tiezhu Yang" <kernelpatch@126.com> wrote:

> I read drivers/md/raid5.c and find the following related code:
> 1) in function 'raid5_set_cache_size':
> if (size <= 16 || size > 32768)
> 	return -EINVAL;
> 2) #define NR_STRIPES		256
> 
> So the lower limit value of stripe_cache_size should be 17 and
> the default value should be 256.

Applied to the docs tree, thanks.

jon
