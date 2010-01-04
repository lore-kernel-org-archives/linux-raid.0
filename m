From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Mon, 4 Jan 2010 23:51:33 +0200
Message-ID: <7b3edae11001041351o141b2616x381e2e671f4a2987@mail.gmail.com>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
	 <72dbd3151001041314w511385deh38b54add67e098e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3151001041314w511385deh38b54add67e098e0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Mr. Rees and thank you for replying.

I have read this post and it is very good but it mentions alignment
of the partitions using special CHS values and LVM/ext4 options.

My partitions and both LUKS/LVM are aligned properly (at least i think
they are). I am worried about the alignment of RAID itself.

2010/1/4 David Rees <drees76@gmail.com>:
> On Mon, Jan 4, 2010 at 11:30 AM, Khelben Blackstaff
> <eye.of.the.8eholder@gmail.com> wrote:
>> Is there a way to make the RAID data start at a particular offset ?
>> (In my case 512 sectors) ?
>
> http://thunk.org/tytso/blog/2009/02/20/aligning-filesystems-to-an-ssds-erase-block-size/
>
> May have to tweak your fdisk parameters a bit.
>
> Don't worry about aligning your /boot partition since you don't
> read/write from that much.
>
> -Dave
>
