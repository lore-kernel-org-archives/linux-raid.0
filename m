From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Wed, 3 Mar 2010 07:17:01 +1100
Message-ID: <20100303071701.040f2a51@notabene.brown>
References: <4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<4B853BBF.7000607@tmr.com>
	<yq1ocjemx46.fsf@sermon.lab.mkp.net>
	<20100225083936.07cd48ad@notabene.brown>
	<20100228080949.GA30574@maude.comedia.it>
	<20100302160100.621f9811@notabene.brown>
	<20100302073624.GA28827@maude.comedia.it>
	<4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
	<20100302110232.GA14131@maude.comedia.it>
	<4B8D5581.8070509@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B8D5581.8070509@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 02 Mar 2010 19:14:25 +0100
Asdo <asdo@shiftmail.org> wrote:

> Luca Berra wrote:
> >>>
> >>> I will try to explain better,
> >>> the problem is not related to the confusion between B or B'
> >>>
> >>> the problem is that on one disk we have B' _without_ C.
> >>>
> >> You're demanding full atomic commits; this is precisely what journals
> >> and /barriers/ are for.
> >>
> >> Are you are bypassing them in a quest for performance and paying for
> >> it on crashes?
> >> Or is this a hardware bug?
> >> Or is it some glitch in the block device layering leading to barrier
> >> requests not being honored?
> > I just asked for confirmation that with /barriers/ the scenario above
> > would not happen.
> >
> 
> I think so, that it would not happen: the filesystem would stay 
> consistent. (while the mismatches could still happen)
> 
> The problem is that the barriers were introduced in all md raids in the 
> 2.6.33 (just released), and also I have read XFS has a major performance 
> drop with barriers activated. People will be tempted to disable 
> barriers. AFAIR the performance drop was visible with 1 disk alone, 
> imagine now with RAID. And I expect similar performance drops with other 
> filesystems, correct me if I am wrong.

The barrier support added in 2.6.33 was for striped md arrays.
RAID1, which is not striped, has had barrier support since about 2.6.16,
as it is much easier to implement.

NeilBrown

> 
> Now it would be interesting to understand why the mismatches don't 
> happen when LVM is above MD-raid!?
> The mechanisms presented up to now on this ML for mismatches don't 
> explain why on LVM the same issue doesn't show up. I think.
> So you might want to use raid-1 and raid-10 under LVM, just in case....
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

