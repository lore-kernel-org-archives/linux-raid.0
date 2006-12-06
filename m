From: "Michael Yao" <danshoe@gmail.com>
Subject: Re: Questions about RAID1/RAID5 read error handling
Date: Wed, 6 Dec 2006 17:10:56 +0800
Message-ID: <c03b90ed0612060110p2c3f2186wb462ce45f9f6e445@mail.gmail.com>
References: <c03b90ed0612050442i2d41d274i3edf0c84c269b523@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c03b90ed0612050442i2d41d274i3edf0c84c269b523@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I summarized my readings from the mail list, hope that someone can
correct me if I am wrong, thanks.

1. When md is degraded or during recoverying, read error is FATAL and
non-recoverable.

2. After 2.6.16, RAID1 auto-correct read errors by re-write the block
during resync or normal IO.

3. After 2.6.15, RAID5 auto-correct read errors by re-write the block
on normal IO.

4. There is still one thing I do not know is that "How will RAID5
handle read errors during resync?"

Thanks for your kind help : )

--
Best Regards,
Michael Yao


On 12/5/06, michael michael <danshoe@gmail.com> wrote:
> Hi,
>
> I have several questions about RAID1/RAID5 read error handling.
> Any help is appreciated, thanks.
>
> After I created a md, what will md driver do if a read error is
> encountered in the following conditions:
> 1. during md is resyncing?
> 2. after md is resync-ed?
> 3. when md is degraded?
> 4. during md is recovering?
>
> My current kernel is 2.6.15.7, but I saw patches for the read errors
> handling in 2.6.16/18.
> What are the changes of read error handling after 2.6.16?
