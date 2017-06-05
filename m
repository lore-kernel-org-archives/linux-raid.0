From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md: simplify code with bio_io_error
Date: Mon, 5 Jun 2017 11:11:55 +0800
Message-ID: <32a5d968-0363-c1e0-a4eb-77a916a30de9@suse.com>
References: <20170602074914.26842-1-gqjiang@suse.com>
 <20170602162926.onnaflcf26ahuoti@kernel.org>
 <20170603055742.GA19486@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170603055742.GA19486@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 06/03/2017 01:57 PM, Christoph Hellwig wrote:
> On Fri, Jun 02, 2017 at 09:29:26AM -0700, Shaohua Li wrote:
>> On Fri, Jun 02, 2017 at 03:49:14PM +0800, Guoqing Jiang wrote:
>>> bio_io_error was introduced in the commit 4246a0b
>>> ("block: add a bi_error field to struct bio"), so
>>> use it to simplify code.
>>>
>>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> Applied, thanks! There are several other places which could use conversion, I added
> Ugg.  I have a massive series pending for the block layer that changes
> the error values.  Applying these cleanups now will just introduce
> conflicts all over.
>

Hmm, I suppose you mean the thread with subject "dedicated error codes 
for the block layer"
which replace bi_error with bi_status. I can resend it on top of the 
thread, or maybe you can
add the changes in your patches directly.

Thanks,
Guoqing

