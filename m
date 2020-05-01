From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [RFC PATCH V2 1/9] include/linux/pagemap.h: introduce
 attach/clear_page_private
Date: Fri, 1 May 2020 08:41:37 +0200
Message-ID: <aacdc25b-4650-6251-acf5-5c2c8b77f292@cloud.ionos.com>
References: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
 <20200430214450.10662-2-guoqing.jiang@cloud.ionos.com>
 <20200430221338.GY29705@bombadil.infradead.org>
 <20200501014229.GB23230@ZenIV.linux.org.uk>
 <20200501014954.GC23230@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200501014954.GC23230@ZenIV.linux.org.uk>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, david@fromorbit.com, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, William Kucharski <william.kucharski@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andreas Gruenbacher <agruenba@redhat.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Anton Altaparmakov <anton@tuxera.com>, linux-ntfs-dev@l
List-Id: linux-raid.ids

On 5/1/20 3:49 AM, Al Viro wrote:
> On Fri, May 01, 2020 at 02:42:29AM +0100, Al Viro wrote:
>> On Thu, Apr 30, 2020 at 03:13:38PM -0700, Matthew Wilcox wrote:
>>
>>>> +/**
>>>> + * clear_page_private - clear page's private field and PG_private.
>>>> + * @page: page to be cleared.
>>>> + *
>>>> + * The counterpart function of attach_page_private.
>>>> + * Return: private data of page or NULL if page doesn't have private data.
>>>> + */
>>> Seems to me that the opposite of "attach" is "detach", not "clear".
>> Or "remove", perhaps...
> Actually, "detach" is better - neither "clear" nor "remove" imply "... and give
> me what used to be attached there", as this thing is doing.

Ok, seems we have reached the agreement about the new name ;-), will 
follow the instruction.

Thanks & Regards,
Guoqing
