From: Duane <duane@evenson.tk>
Subject: Re: very large data-offset?
Date: Mon, 4 Dec 2017 20:33:07 -0700
Message-ID: <216131fc-ef9d-2650-18a4-d2512e8b6f81@evenson.tk>
References: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk>
 <87po7vtiw2.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------78D917A462A34623BECE67B4"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87po7vtiw2.fsf@notabene.neil.brown.name>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------78D917A462A34623BECE67B4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2017-12-03 05:51 PM, NeilBrown wrote:
> On Thu, Nov 30 2017, Duane wrote:
>
>> Why is the data offset set so big? I created a 3x4TB RAID5 array and the
>> data offset was 128MB. Chunk size was the default 512kB.
> It is less than 0.1% of the device...
>
>> I cannot see why such a large offset is used. I would think the data
>> offset need only be at most the chunk size plus the space (1 sector) for
>> the superblock and bitmap.
> It is insurance.  If you want to change the chunksize later, having a
> lot of head-room will allow the reshape to go much faster.
>
>> When reshaping the array, I am prompted to use an external file, so I
>> don't see that mdadm ever uses the space.
> Citation needed.... what version of mdadm, what kernel?  What reshape
> command?
kernel:  9.64-1-lts
mdadm:  mdadm - v4.0 - 2017-01-09
action:  reduce the number of raid devices
>>
>> I tried making some test arrays and got much smaller sizes. A 3x1GB
>> RAID5 array with 64k chunks had a 1MB data offset.
>>
>>
>> If I make a 7x4TB RAID5 array with 64kB chunks, is there a problem with
>> setting the data offset to around 2MB?
> Only that it might reduce your options in the future, though probably
> not by much.
>
> NeilBrown


--------------78D917A462A34623BECE67B4
Content-Type: text/x-vcard;
 name="duane.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="duane.vcf"

bnVsbA==
--------------78D917A462A34623BECE67B4--
