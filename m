From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Wed, 21 Sep 2005 01:01:42 +1000
Message-ID: <17200.9302.242957.23189@cse.unsw.edu.au>
References: <20050920143346.GA5777@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steinar H. Gunderson on Tuesday September 20
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 20, sgunderson@bigfoot.com wrote:
> (Please Cc me on any replies, I'm not subscribed)
ofcourse...
> 
> Hi,
> 
> Attached is a patch (against 2.6.12) for adding online RAID-5 resize
> capabilities to Linux' RAID code.

Wow!  Thanks for this.  It's been something that I wanted to be done
for some time, but it hasn't got even close to the top of my todo
list.

> 
> - It's RAID-5 only; I don't really use RAID-0, and RAID-6 would probably be
>   more complex.

I doubt raid6 would be much more difficult.  However it is definitely
best to get it working well in raid5 first.
I'd never thought of doing raid0, but I cannot now think of a good
reason not to.....


> - It supports only growing, not shrinking. (Not sure if I really care about
>   fixing this one.)

Shrinking certainly adds a lot of complications, and you would have to
start at the 'top' and work backwards.  Probably not worth the effort,
except that people might want to be able to back-out a change...

> - It leaks memory; it doesn't properly free up the old stripes etc. at the
>   end of the resize. (This also makes it impossible to do a grow and then
>   another grow without stopping and starting the volumes.)

I'm sure that can be fixed.

> - There is absolutely no crash recovery -- this shouldn't be so hard to do
>   (just update the superblock every time, with some progress meter, and
>   restart from that spot in case of a crash), but I have no knowledge of the
>   on-disk superblock format at all, so some help would be appreciated here.
>   Also, I'm not really sure what happens if it encounters a bad block during
>   the restripe.

Crash recovery is essential I think.  There are some awkward cases,
particularly while growing the first few stripes.  I'm sure we can
work it out together.


> - It's quite slow; on my test system with old IDE disks, it achieves about
>   1MB/sec. One could probably make a speed/memory tradeoff here, and move
>   more chunks at a time instead of just one by one; I'm a bit concerned
>   about the implications of the kernel allocating something like 64MB in one
>   go, though :-)

I doubt speed is a top priority.

I'll try to have a read through your code over the next week or so and
give you more detailed feedback.

Thanks again,
NeilBrown
