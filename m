From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Write journal sizing
Date: Mon, 24 Jul 2017 11:22:12 -0400
Message-ID: <60abb68c-790b-42a0-3fbd-967b4cf877e5@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 From what I read at the link below, the write journal mirrors the 
contents of the stripe cache. This suggests that the write journal 
cannot contain more uncommitted data than the stripe cache can hold. Is 
that correct?

https://www.kernel.org/doc/Documentation/md/raid5-cache.txt

So, if the stripe cache size is 1GB then is there any advantage in 
making the journal device larger than 1GB? I assume no, but I'm also 
wondering about journal overhead.

My understanding is that the stripe cache size is limited to 32768 and 
that the total memory size is the size value x 4096 x num disks. IOW, 
max 128MB per disk (32k x 4k x 1). Is that correct?

--Larkin
