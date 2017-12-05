From: Duane <duane@evenson.tk>
Subject: Re: very large data-offset?
Date: Mon, 4 Dec 2017 20:26:19 -0700
Message-ID: <90b20eae-9e2a-749f-abd7-36f4c8f252c2@evenson.tk>
References: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk>
 <5A1FE135.8090000@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------FB786407F8C4966FBEC84EC2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A1FE135.8090000@youngman.org.uk>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------FB786407F8C4966FBEC84EC2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2017-11-30 03:45 AM, Wols Lists wrote:
> On 30/11/17 10:26, Duane wrote:
>> Why is the data offset set so big? I created a 3x4TB RAID5 array and the
>> data offset was 128MB. Chunk size was the default 512kB.
>>
>> I cannot see why such a large offset is used. I would think the data
>> offset need only be at most the chunk size plus the space (1 sector) for
>> the superblock and bitmap.
>>
>> When reshaping the array, I am prompted to use an external file, so I
>> don't see that mdadm ever uses the space.
>>
> Do you mean the manual tells you, or that mdadm refuses to run otherwise?
>
> Certainly with a new array on larger disks, a backup file should be
> totally unnecessary.
>
> Run a reshape of some sort, and see if the offset changes :-)
Reshaping won't run and suggests the use of the backup file.
I like the way mdadm gives helpful hints rather than fails quietly. :)

I don't have the space right now to grow the array device sizes and 
watch for changes in the data offset.
It is going on my todo list for when I've quit reshaping my filesystem 
and things have stabilized.
>> I tried making some test arrays and got much smaller sizes. A 3x1GB
>> RAID5 array with 64k chunks had a 1MB data offset.
>>
>>
>> If I make a 7x4TB RAID5 array with 64kB chunks, is there a problem with
>> setting the data offset to around 2MB?
>>
> Dunno. How do you know the bitmap is "just one block"? I haven't dug in
> to it so I don't know, but it makes sense to me that as the disks get
> bigger, so does the bitmap.
I misspoke. I wasn't paying too much attention to bitmaps: just saw a 
value for bitmap offset in the header and assumed I had a bitmap. 
Further investigation due to your question showed that I don't have a 
bitmap by default.
>
> What's the point of fighting the defaults, anyway? Just add
> another/bigger disk if you need more space.
I'm poor; 5, now 6 disks are my budget's limit. :(
>
> Cheers,
> Wol
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------FB786407F8C4966FBEC84EC2
Content-Type: text/x-vcard;
 name="duane.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="duane.vcf"

bnVsbA==
--------------FB786407F8C4966FBEC84EC2--
