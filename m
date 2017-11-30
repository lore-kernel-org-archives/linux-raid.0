From: Duane <duane@evenson.tk>
Subject: very large data-offset?
Date: Thu, 30 Nov 2017 03:26:50 -0700
Message-ID: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------A8311C2B0C3105573F57023F"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------A8311C2B0C3105573F57023F
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Why is the data offset set so big? I created a 3x4TB RAID5 array and the 
data offset was 128MB. Chunk size was the default 512kB.

I cannot see why such a large offset is used. I would think the data 
offset need only be at most the chunk size plus the space (1 sector) for 
the superblock and bitmap.

When reshaping the array, I am prompted to use an external file, so I 
don't see that mdadm ever uses the space.


I tried making some test arrays and got much smaller sizes. A 3x1GB 
RAID5 array with 64k chunks had a 1MB data offset.


If I make a 7x4TB RAID5 array with 64kB chunks, is there a problem with 
setting the data offset to around 2MB?


Thanks


--------------A8311C2B0C3105573F57023F
Content-Type: text/x-vcard;
 name="duane.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="duane.vcf"

bnVsbA==
--------------A8311C2B0C3105573F57023F--
