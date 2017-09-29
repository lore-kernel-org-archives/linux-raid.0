From: Eli Ben-Shoshan <eli@benshoshan.com>
Subject: Re: Accidentally resized array to 9
Date: Fri, 29 Sep 2017 10:53:57 -0400
Message-ID: <fec79486-8f23-74dd-9c62-4f89ac00b95d@benshoshan.com>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
 <20170929175524.57fea3b5@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170929175524.57fea3b5@natsu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On 09/29/2017 08:55 AM, Roman Mamedov wrote:
> On Fri, 29 Sep 2017 00:23:28 -0400
> Eli Ben-Shoshan <eli@benshoshan.com> wrote:
> 
>> This was a RAID6 with 8 devices. Instead of using --grow with
>> --raid-devices set to 9, I did the following:
>>
>> mdadm --grow /dev/md128 --size 9
>>
>> This happily returned without any errors so I went to go look at
>> /proc/mdstat and did not see a resize operation going. So I shook my
>> head and read the output of --grow --help and did the right thing which is:
>>
>> mdadm --grow /dev/md128 --raid-devices=9
> 
> The output of the first command is:
> 
>    # mdadm --grow /dev/md0 --size 9
>    mdadm: component size of /dev/md0 has been set to 9K
>    unfreeze
> 
> It didn't occur to you that you FIRST need to restore the "component size" back
> to what it was previously?...

I am not sure that I actually got any response at all from setting 
--size. I am running version:

mdadm - v3.4 - 28th January 2016

If I did get output, I totally missed it. I get that this is my fault 
for using the wrong commmand and any data loss is totally due to my 
stupidity. I am just hoping that there might be a way that I can get the 
data back.

> 
> And yes as John says there should be a confirmation request on reducing the
> array size. In fact I couldn't believe there isn't one already, that's why I
> went checking. But nope, there are no warnings or confirmation requests
> neither for reducing --size, nor --array-size. I might be remembering that
> there were some, from LVM, not MD.
> 

