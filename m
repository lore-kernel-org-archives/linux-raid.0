From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Superblock Missing
Date: Sat, 2 Sep 2017 18:49:06 +0200
Message-ID: <20170902164906.GA6823@metamorpher.de>
References: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
 <20170902014333.GA26507@metamorpher.de>
 <CAANkkpK6jeFKr-Tz2Fzq-CTey0GJRmERy0W+DBHMVJct2JYfUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANkkpK6jeFKr-Tz2Fzq-CTey0GJRmERy0W+DBHMVJct2JYfUQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Mitchell <mr.david.mitchell@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 02, 2017 at 11:43:49AM -0400, David Mitchell wrote:
> Sorry I'm still confused.
> While the array seems alive, the filesystem seems to be missing?

Hello David,

I'm the one who is confused here.

You posted to the raid mailing list about a superblock, and you even 
posted the mdadm command and error message to go along with it. 
How did it turn into a filesystem problem now? In your last mail, 
I did not see that at all.

This was what you posted and I thought you were referring to:

> # mdadm --examine /dev/md0
> mdadm: No md superblock detected on /dev/md0.

And thus that was the part I referred to in my answer.

----

> # mdadm --detail /dev/md*
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sat Aug 26 16:21:20 2017
>      Raid Level : raid5

So according to this, your RAID was created about a week ago. 

You did write that you just migrated to 4TB drives. There are various ways 
to go about that, making a new RAID and copying stuff over from the 
old one is not unusual. So this creation time might be perfectly normal.

Of course if this migration happened more than one week ago then I can 
only assume you used mdadm --create to fix some RAID issue or other? 

mdadm --create is like mkfs: you don't expect data to exist afterwards.
For mdadm --create to retain data you have to get all settings perfectly 
right and those settings change depending on when you originally created 
it and what you did with it since (e.g. mdadm --grow might change offsets).

I'm not sure how to help you because nothing in your mails explains 
how this issue came about.

There are previous discussions on this list about botched mdadm --create, 
wrong data offsets, and searching for correct filesystem offsets.

Whatever you do, don't write on these drives while looking for lost data. 

Regards
Andreas Klauer
