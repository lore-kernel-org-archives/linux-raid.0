From: David Brown <david.brown@hesbynett.no>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 20:54:05 +0200
Message-ID: <4DBEFDCD.80507@hesbynett.no>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net> <1304051980.3105.46.camel@localhost> <8739kyf53e.fsf@servo.factory.finestructure.net> <4DBE753D.20709@westcontrol.com> <87k4e9cb2q.fsf@servo.factory.finestructure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k4e9cb2q.fsf@servo.factory.finestructure.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: David Brown <david@westcontrol.com>, Ben Hutchings <ben@decadent.org.uk>, 624343@bugs.debian.org, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/11 18:38, Jameson Graef Rollins wrote:
> On Mon, 02 May 2011 11:11:25 +0200, David Brown<david@westcontrol.com>  wrote:
>> This is not directly related to your issues here, but it is possible to
>> make a 1-disk raid1 set so that you are not normally degraded.  When you
>> want to do the backup, you can grow the raid1 set with the usb disk,
>> want for the resync, then fail it and remove it, then "grow" the raid1
>> back to 1 disk.  That way you don't feel you are always living in a
>> degraded state.
>
> Hi, David.  I appreciate the concern, but I am not at all concerned
> about "living in a degraded state".  I'm far more concerned about data
> loss and the fact that this bug has seemingly revealed that some
> commonly held assumptions and uses of software raid are wrong, with
> potentially far-reaching affects.
>
> I also don't see how the setup you're describing will avoid this bug.
> If this bug is triggered by having a layer between md and the filesystem
> and then changing the raid configuration by adding or removing a disk,
> then I don't see how there's a difference between hot-adding to a
> degraded array and growing a single-disk raid1.  In fact, I would
> suspect that your suggestion would be more problematic because it
> involves *two* raid reconfigurations (grow and then shrink) rather than
> one (hot-add) to achieve the same result.  I imagine that each raid
> reconfiguration could potentially triggering the bug.  But I still don't
> have a clear understanding of what is going on here to be sure.
>

I didn't mean to suggest this as a way around these issues - I was just 
making a side point.  Like you and others in this thread, I am concerned 
about failures that could be caused by having the sort of layered and 
non-homogeneous raid you describe.

I merely mentioned single-disk raid1 "mirrors" as an interesting feature 
you can get with md raid.  Many people don't like to have their system 
in a continuous error state - it can make it harder to notice when you 
have a /real/ problem.  And single-disk "mirrors" gives you the same 
features, but no "degraded" state.

As you say, it is conceivable that adding or removing disks to the raid 
could make matters worse.

 From what I have read so far, it looks like you can get around problems 
here if the usb disk is attached when the block layers are built up 
(i.e., when the dm-crypt is activated, and the lvm and filesystems on 
top of it).  It should then be safe to remove it, and re-attach it 
later.  Of course, it's hardly ideal to have to attach your backup 
device every time you boot the machine!



