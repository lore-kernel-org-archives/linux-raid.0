From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Help please: 2-5 tps on write with 98% iowait
Date: Wed, 25 Jan 2012 19:03:02 +0000
Message-ID: <4F2051E6.1020203@anonymous.org.uk>
References: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Seth Jennings <spartacus06@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/01/2012 18:15, Seth Jennings wrote:
[...]
> write /home:
>
> dd if=/dev/zero of=zeroes
> <ctrl-c>
> 208385+0 records in
> 208384+0 records out
> 106692608 bytes (107 MB) copied, 27.6739 s, 3.9 MB/s
[...]
> so writing is aweful (2-5 tps per disk with 98% iowait?!).
>
> write /dev/sdc1 (non-raid part in /dev/sdc)
>
> dd if=/dev/zero of=zeroes bs=4096 count=100000
> 100000+0 records in
> 100000+0 records out
> 409600000 bytes (410 MB) copied, 2.64131 s, 155 MB/s
[...]
> so writing to non-raid partition of one of the disks is good.

You should be comparing apples with apples. Try the single drive test 
again without bs=4096, the md test again with bs=4096, then both again 
with bs=64K, bs=192K, bs=1M.

Cheers,

John.

