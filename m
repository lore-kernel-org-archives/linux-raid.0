From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 08/16] md/bitmap: Rename a jump label in location_store()
Date: Wed, 28 Sep 2016 23:16:01 -0400
Message-ID: <57EC8771.3000700@suse.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
 <d4de2fd9-93a6-9731-13a4-9b02a6c7f971@users.sourceforge.net>
 <wrfjy42b94uu.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <wrfjy42b94uu.fsf@redhat.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids



On 09/28/2016 03:55 PM, Jes Sorensen wrote:
> SF Markus Elfring <elfring@users.sourceforge.net> writes:
>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Tue, 27 Sep 2016 15:46:22 +0200
>>
>> Adjust jump labels according to the current Linux coding style convention.
>>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> ---
>>   drivers/md/bitmap.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
> Sorry but this patch is just plain ridiculous. It does not improve the
> code in any shape or form.
>
> 'out' as a label is perfectly legitimate and just as good as 'unlock'.

Agree, I also curious which document recorded the coding style convention.

Thanks,
Guoqing

