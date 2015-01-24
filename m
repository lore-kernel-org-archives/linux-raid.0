From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: Re: BUG drivers/md/md.c: data-offset reshape renders array unloadable
Date: Sat, 24 Jan 2015 23:23:18 +0100
Message-ID: <CAA-O0XgXc0H4H__8ygLzt_BBW3NpEseG9NZBTZ_syMdir8D=mA@mail.gmail.com>
References: <CAA-O0Xjustt5=nNoDzXukY=f-7OwRk=yqug8MCpxcXCt4MdiTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA-O0Xjustt5=nNoDzXukY=f-7OwRk=yqug8MCpxcXCt4MdiTw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 24, 2015 at 10:44 PM, Wesley W. Terpstra <wesley@terpstra.ca> wrote:
> The reshape was going fine and was probably
> around 50% done when the system was rebooted.

It is also possible the system was hung, but continued the reshape
until completion.

> First, it is obviously the last test in super_1_load that is rejecting
> the array. The superblock reports more sectors than are calculated, so
> the check
>         if (sectors < le64_to_cpu(sb->data_size)) {
> fails.

Thus, an alternative explanation could be that the the sb->data_size
was not updated after the reshape completed. The superblocks have a
"Feature Map: 0x0" according to mdadm. I gather from reading
linux/raid/md_p.h that it should at least have
MD_FEATURE_RESHAPE_ACTIVE, if the reshape were still in progress.
