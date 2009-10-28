From: "Majed B." <majedb@gmail.com>
Subject: Re: md software raid
Date: Wed, 28 Oct 2009 04:10:55 +0300
Message-ID: <70ed7c3e0910271810t368f3081g3db4411ab073b531@mail.gmail.com>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com>
	<20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com> <70ed7c3e0910271758r3f10b79fw99375299ed721f1e@mail.gmail.com>
	<4AE7955B.3020501@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE7955B.3020501@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Richard for the update!

Though with the recent performance drops of XFS on 2.6.3x kernels, and
the fact that the XFS patches are fairly new (and probably buggy), I'd
rather stay away from XFS for a while and look into other possible
options. If any...

On Wed, Oct 28, 2009 at 3:50 AM, Richard Scobie <richard@sauce.co.nz> wrote:
> Majed B. wrote:
>>
>> Indeed xfs_repair doesn't require the abusive amount of memory
>> xfs_check requires.
>>
>> I've been a happy XFS user for a few years now, but the fact the
>> xfsprogs aren't being maintained properly and xfs_check is still a
>> failure, I'm considering other alternatives.
>
> This should change soon, see the September entry:
>
> http://xfs.org/index.php/XFS_Status_Updates
>
> "On the userspace side a large patch series to reduce the memory usage in
> xfs_repair to acceptable levels was posted, but not yet merged."
>
> Regards,
>
> Richard
>



-- 
       Majed B.
