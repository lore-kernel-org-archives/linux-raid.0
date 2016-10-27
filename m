From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: recovering failed raid5
Date: Thu, 27 Oct 2016 21:34:34 +0100
Message-ID: <20161027203433.GA19489@cthulhu.home.robinhill.me.uk>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu Oct 27, 2016 at 04:06:14PM +0100, Alexander Shenkin wrote:

> Hello all,
> 
> A RAID newbie here - apologies in advance for any bonehead questions.
> I have 4 3TB disks that participate in 3 raid arrays.  md2 is failing.
> I'm hoping someone here might be able to give me pointers for the
> right direction to take to avoid data loss, if possible, and recover
> the array.
> 
<- snip ->
> SCT Error Recovery Control command not supported
> SCT Error Recovery Control command not supported
> SCT Error Recovery Control command not supported
> SCT Error Recovery Control command not supported

Others have already chimed in about the recovery process. I just wanted
to make sure you were aware that none of your drives support
TLER/SCTERC. See https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
for details on why this is an issue and how to work around it. You'll
need to do this before attempting any sort of recovery or you're likely
to run into further problems.

Cheers,
    Robin
