From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: md: Combine two kmalloc() calls into one in sb_equal()
Date: Fri, 9 Dec 2016 21:05:45 +0100
Message-ID: <e25d2f8a-8ee9-c541-dac4-a254502df293@users.sourceforge.net>
References: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
 <1481310314.5946.40.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481310314.5946.40.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

> 	tmp1 = kmemdup(sb1, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32), GFP_KERNEL);

Is a function available in the Linux programming interface which would duplicate
the beginning of two array elements in a single call directly?

Regards,
Markus
