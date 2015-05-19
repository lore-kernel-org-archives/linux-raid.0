From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: 20 disks, fastest possible mostly-sequential read speeds
Date: Tue, 19 May 2015 14:45:32 +1000
Message-ID: <555ABFEC.40606@websitemanagers.com.au>
References: <CAKuK5J3CvbhVdyiEO8GrTje9xXq5u1eD96961vF9rA=fzAu6xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J3CvbhVdyiEO8GrTje9xXq5u1eD96961vF9rA=fzAu6xg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/05/15 12:37, Jon Nelson wrote:
> I'm looking for some advise on tuning.
> I have a server with 20 disks behind an LSI 9271-something.
> They are currently exposed as 20 individual raid0 with a "strip" size
> of 1MB,
Ummm, you have 20 disks connected to some raid controller, which 
presents them as 20 raid0 arrays? Or are they raid0 arrays consisting of 
only one disk? or JBOD? or something else?

> and assembled into an mdraid, meta 1.2, layout 10 format f2,
> with a 1MB chunk size and formatted using ext4 -T largefile.
> To date, this has given me the best numbers when reading some 10,000
> files (total size: about 2.5TB) sequentially or in parallel.

What other things did you try?
How did you measure this?
What answers did you get?

> I can't seem to get better than about 1,800 MB/s read speeds though. I
> *should* be able to get closer to 3,000 based on what the drives are
> capable of. Quite some time ago on this very hardware I saw a
> sustained 2,750 MB/s but I don't remember how I got there.
Are you looking for sequential or random access? You will get very 
different numbers for each of these.
> readahead values have been adjusted, I/O scheduler, etc... all played
> with with some benefit but nothing huge. What should I be looking at
> here if I want the best possible read performance?
>
> I don't want to give up some measure of redundancy.

The clue here is to test and measure, and keep a record of the results. 
It can be really frustrating when you can't get the same good result you 
had last week. IME, it is a matter of testing something different, and 
that is why the result is different.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
