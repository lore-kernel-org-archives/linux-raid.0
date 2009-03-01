From: =?ISO-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>
Subject: Re: Raid6 write performance
Date: Sun, 1 Mar 2009 20:12:43 +0100
Message-ID: <6c4602af0903011112o440d7a4i22a24b58ada58865@mail.gmail.com>
References: <49742E74.9090502@rabbit.us> <49A88DB4.40008@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49A88DB4.40008@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

2009/2/28 H. Peter Anvin <hpa@zytor.com>:
> Peter Rabbitson wrote:
>> Hi,
>>
>> I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
>> having is that no matter what chunk size I use, the write benchmark
>> always comes out at single drive speed, although I should be seeing
>> double drive speed (read speed is at near 4x as expected).
>
> I have no idea why you "should" be seeing double drive speed.  All
> drives have to be written, so you'd logically see single drive speed.

I'm afraid that might be incorrect.

Let's assume we want to write 100MB of data onto a 4 drive raid6.
Let's divide 100MB of data into two parts, say A and B, each 50MB big.
Writing the data on the raid, would mean writing:
* A on disk1
* B on disk2
* XOR(A,B) on disk3
* Q(A,B) on disk4
That is actually assuming 50MB chunk, and whole chunk writes, etc.
Each of written portions would have been 50MB in size. That sounds
reasonable to me, as with 2 data disks, only half of data has to be
written on each. The fact that disks are really striped with data, XOR
and Q doesn't change the image in terms of amount written.

I do hope I had understood the situation correctly, but I'll be ever
happy to be proved wrong.

Kind regards,
Mike
