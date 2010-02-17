From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 15:13:46 +0000
Message-ID: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I remember seeing some discussion on what sector a partition starts
on. Many programs create partitions that start on sector 63, which
doesn't really make any intuitive sense to me. I just lost a disk from
of a RAID10 array and was thinking I'd try to understand this issue as
I have to do some disk/block/partition wrangling anyway.

From a discussion from linux-raid titled "Raid 10 LVM JFS Seeking
performance help", I found the following:

On Mon, Dec 21, 2009 at 12:56 PM, Goswin von Brederlow
<goswin-v-b@web.de> wrote:
>
> Also, on a lower level, make sure your raid does not start on a
> partition starting at sector 63 (which is still the default in many
> partitioning progs). That easily results in bad alignment causing 4k
> chunks to land on 2 sectors. But you need to test that with your
> specific drive to see if it really is a problem.
>

Hmm ... In short: Do I want to have a partition start on any
particular sector? Especially in the case where I want to ...
- build a RAID10 with partitions (i.e. not with raw devices)
- using ~256K chunks
- and have a nice JFS filesystem on top of it.

Starting on sector 64 feels conceptually "prettier" than Sector 63,
but I can't picture the case where it behaves any different. Except
perhaps when GRUB expects stuff to begin at sector 63, making a mess
if we're starting at sector 64. Though it *should* work OK, of course.

Anyways ... Any tips on a subtle matter most well appreciated.
Especially tell me if I'm overthinking, please. Thanks.

-- Kristleifur
