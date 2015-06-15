From: Charles Bertsch <cbertsch@cox.net>
Subject: Re: Fw: Problems with bdev_write_page().
Date: Mon, 15 Jun 2015 07:19:17 -0700
Message-ID: <557EDEE5.60600@cox.net>
References: <20150611064126.1d05dc20@home.neil.brown.name> <fSoD1q00Z1Qq7Ka01SoEyb>
Reply-To: bertschc@acm.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fSoD1q00Z1Qq7Ka01SoEyb>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "BertschC@acm.org" <BertschC@acm.org>
List-Id: linux-raid.ids

On 06/12/2015 07:48 AM, Matthew Wilcox wrote:
...
>>
>> Can you propose a fix for Charles, who can trigger this bug and nicely
>> bisected it for us - thanks Charles!!!
>
....
>
> (this patch probably doesn't apply to the current tree; it's done against
> a bit of a mishmash tree in my current working directory.  it's not for
> applynig, but for commentary).
>
Matthhew,

I tested again with v4.1-rc7, bug still present.

I was able to apply the patch (at offsets -10, -1, -8 for 
fs/block_dev.c, fs/mpage.c, and mm/page_io.c).  That test has been 
running without error for 14 hours.  The bug would occur with this setup 
within 10 minutes.

Thanks.

Charles Bertsch
