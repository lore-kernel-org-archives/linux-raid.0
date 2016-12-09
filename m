From: Joe Perches <joe@perches.com>
Subject: Re: md: Combine two kmalloc() calls into one in sb_equal()
Date: Fri, 09 Dec 2016 12:51:56 -0800
Message-ID: <1481316716.5946.42.camel@perches.com>
References: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
         <1481310314.5946.40.camel@perches.com>
         <e25d2f8a-8ee9-c541-dac4-a254502df293@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e25d2f8a-8ee9-c541-dac4-a254502df293@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2016-12-09 at 21:05 +0100, SF Markus Elfring wrote:
> > 	tmp1 = kmemdup(sb1, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32), GFP_KERNEL);
> 
> Is a function available in the Linux programming interface which would duplicate
> the beginning of two array elements in a single call directly?

No.  If there were, there would be a good argument to remove it.
