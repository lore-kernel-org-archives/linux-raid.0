From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Full use of varying drive sizes?---maybe a new raid mode is the
 answer?
Date: Thu, 24 Sep 2009 18:23:04 +0100
Message-ID: <4ABBAAF8.5060407@anonymous.org.uk>
References: <228790.21625.qm@web51307.mail.re2.yahoo.com> <4ABA8506.3080800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ABA8506.3080800@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/09/2009 21:28, Konstantinos Skarlatos wrote:
> Instead of doing all those things, I have a suggestion to make:
> 
> Something that is like RAID 4 without striping.
> 
> There are already 3 programs doing that, Unraid, Flexraid and disparity, 
[...]
> Disk     A    B   C   D   E    P
> Block   1    1    1    1    1    1
> Block   2    2    2                2
> Block   3    3                      3
> Block   4                            4

This is exactly what I want for a particular application I was thinking 
of putting together. I want to offer my customers nightly backups over 
the 'net. That's easy enough, and well off the scope of this list. I was 
going to save the data onto a big RAID of big discs, but I was wondering 
what to do when the customer needs the data, because downloading the 
data would take way too long, and I'm not taking my server offline to 
take to their site. So I thought, hmm, run a disc for each customer, 
plus a parity drive in case anything goes phut. Then when the customer 
needs their data, I can yank their drive and go to their premises with 
their data in hand. Of course, another option would be to copy the data 
onto a spare drive, but even that takes a while if they're in a hurry.

Might have known somebody would already have done it.

Cheers,

John.

