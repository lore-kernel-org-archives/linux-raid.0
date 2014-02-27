From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: Recovering RAID-6 from a Failed Grow
Date: Thu, 27 Feb 2014 09:16:01 +0100
Message-ID: <530EF441.5020804@gmail.com>
References: <CAMuGJSm2EtoMja5dEchFERW0-Mj1Cj0UjU4n55ETeegLkpT_cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMuGJSm2EtoMja5dEchFERW0-Mj1Cj0UjU4n55ETeegLkpT_cw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Wilbur <karl@karlwilbur.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26.02.2014 08:14, Karl Wilbur wrote:
> 
> I have spent several hours now searching Google, reading list
> archives, as well as trying a few things from the wiki (like the
> attempts to re-create the array).
> 
> I feel fairly certain that the filesystem is still intact and should
> mountable, I'm just as a loss as to where to go next. Any ideas or
> suggestions?

I am not an expert on this, but just looking at the output I wonder if
you used the right disk order on the recreate? You have used

> mdadm --create /dev/md0 --level=6 --chunk=64 --size=976762496
> --assume-clean --raid-devices=9 --metadata=0.9 /dev/sdb /dev/sdc
> /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj

b c d e f g h i j

while the original --explain output suggests

>    0     0       8       16        0      active sync   /dev/sdb
>    1     1       0        0        1      faulty removed
>    2     2       8      112        2      active sync   /dev/sdh
>    3     3       0        0        3      faulty removed
>    4     4       8      144        4      active sync   /dev/sdj
>    5     5       8      128        5      active sync   /dev/sdi
>    6     6       0        0        6      faulty removed
>    7     7       8       32        7      active sync   /dev/sdc
>    8     8       8       96        8      active sync   /dev/sdg

b ? h ? j i ? c g

(question marks being missing disks - that is, position has to be guessed).

On the wiki, there is the suggestion of doing any experiments read-only
via a read-write overlay file. This seems to be a very good idea.

> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

Best regards,
Jakob

