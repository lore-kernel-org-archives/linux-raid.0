From: David Rees <drees76@gmail.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Mon, 4 Jan 2010 13:14:01 -0800
Message-ID: <72dbd3151001041314w511385deh38b54add67e098e0@mail.gmail.com>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 4, 2010 at 11:30 AM, Khelben Blackstaff
<eye.of.the.8eholder@gmail.com> wrote:
> Is there a way to make the RAID data start at a particular offset ?
> (In my case 512 sectors) ?

http://thunk.org/tytso/blog/2009/02/20/aligning-filesystems-to-an-ssds-erase-block-size/

May have to tweak your fdisk parameters a bit.

Don't worry about aligning your /boot partition since you don't
read/write from that much.

-Dave
