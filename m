From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 11:21:52 -0400
Message-ID: <51FBCE90.2030603@redhat.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com> <51FAE985.1040809@redhat.com> <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/01/2013 10:01 PM, Roberto Spadim wrote:
> the point is: using swap at two partitions / disks, is "better" than
> using a swap over a md raid1? (or any other level?)

That depends on your goals.  If your goal is for your system to be
resilient to disk failure, and you've put your filesystems on a raid
device to be tolerant of failure, then your swap needs to be on one too
or else you are undermining the work you did on your filesystems.  If
that's not the case, then two swap partitions gets you twice the
capacity, but slightly lower performance, than a raid1 swap device over
the same partitions due to the fact that when you are swapping out,
performance is about the same, but when swapping in, we can load balance
reads and increase performance.  Of course, you only have half as much
swap this way.

> other point is... swap have a badblock feature? i think it's not
> linux-raid but linux-vm or something like it...
> for example if i'm using a disk and swap find a badblock, it will use
> it? does swap handle bad blocks? it remove the device? continue using
> it? or change the device priority?

The swap layer does not do bad blocks *while in use*.  You can pass in a
list of badblocks when creating the device, in which case it won't ever
use those blocks.  However, if a block *goes* bad while in use, and we
get a read error, then whatever application was trying to page in that
page of swap is going to get killed due to an unhandled page fault.

