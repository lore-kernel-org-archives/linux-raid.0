From: Beolach <beolach@gmail.com>
Subject: Re: Successful RAID 6 setup
Date: Sun, 8 Nov 2009 00:07:12 -0700
Message-ID: <aebf5d970911072307u2168cf1am793aa6c4b17a1b14@mail.gmail.com>
References: <4AF1C20C.4090902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF1C20C.4090902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 4, 2009 at 11:03, Andrew Dunn <andrew.g.dunn@gmail.com> wrote:
> I sent this a couple days ago, wondering if it fell through the cracks or if I am asking the wrong questions.
>
> ------
>
> I will preface this by saying I only need about 100MB/s out of my array
> because I access it via a gigabit crossover cable.
>
> I am backing up all of my information right now (~4TB) with the
> intention of re-creating this array with a larger chunk size and
> possibly tweaking the file system a little bit.
>
> My original array was a raid6 of 9 WD caviar black drives, the chunk
> size was 64k. I use USAS-AOC-L8i controllers to address all of my drives
> and the TLER setting on the drives is enabled for 7 seconds.
>
<snip mdadm -D>

That array should easily be able to fill your 100MB/s speed requirement.  If
you really are only accessing over a 1Gib/s link, I wouldn't worry much
about tweaking for performance.

>
> I have noticed slow rebuilding time when I first created the array and
> intermittent lockups while writing large data sets.
>
> Per some reading I was thinking of adjusting my chunk size to 1024k, and
> trying to figure out the weird stuff required when creating a file system.
>

Can you quantify "slow rebuilding time"?  And was that just when you first
created the array, or do you still see slowness when you check/repair the
array?  Using a write-intent bitmap might help here.

I don't know that any of the options discussed so far are likely to help w/
intermittent lockups.  When you see them, are you writing your data over
the network?  How badly does it lock up your system?  What kernel version
are you using?


Good Luck,
--
Conway S. Smith
