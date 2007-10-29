From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 22:29:27 +0100
Message-ID: <20071029212927.GA24635@percy.comedia.it>
References: <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <472576A5.3030603@amfes.com> <20071029081802.GB15475@percy.comedia.it> <1193672839.10336.443.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193672839.10336.443.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 29, 2007 at 11:47:19AM -0400, Doug Ledford wrote:
>On Mon, 2007-10-29 at 09:18 +0100, Luca Berra wrote:
>> On Sun, Oct 28, 2007 at 10:59:01PM -0700, Daniel L. Miller wrote:
>> >Doug Ledford wrote:
>> >>Anyway, I happen to *like* the idea of using full disk devices, but the
>> >>reality is that the md subsystem doesn't have exclusive ownership of the
>> >>disks at all times, and without that it really needs to stake a claim on
>> >>the space instead of leaving things to chance IMO.
>> >>   
>> >I've been re-reading this post numerous times - trying to ignore the 
>> >burgeoning flame war :) - and this last sentence finally clicked with me.
>> >
>> I am sorry Daniel, when i read Doug and Bill, stating that your issue
>> was not having a partition table, i immediately took the bait and forgot
>> about your original issue.
>
>I never said *his* issue was lack of partition table, I just said I
>don't recommend that because it's flaky.  The last statement I made
maybe i misread you but Bill was quite clear.

>about his issue was to ask about whether the problem was happening
>during initrd time or sysinit time to try and identify if it was failing
>before or after / was mounted to try and determine where the issue might
>lay.  Then we got off on the tangent about partitions, and at the same
>time Neil started asking about udev, at which point it came out that
>he's running ubuntu, and as much as I would like to help, the fact of
>the matter is that I've never touched ubuntu and wouldn't have the
>faintest clue, so I let Neil handle it.  At which point he found that
>the udev scripts in ubuntu are being stupid, and from the looks of it
>are the cause of the problem.  So, I've considered the initial issue
>root caused for a bit now.
It seems i made an idiot of myself by missing half of the thread, and i
even knew ubuntu was braindead in their use of udev at startup, since a
similar discussion came up on the lvm or the dm-devel mailing list (that
time iirc it was about lvm over multipath)

>> like udev/hal that believes it knows better than you about what you have
>> on your disks.
>> but _NEITHER OF THESE IS YOUR PROBLEM_ imho
>
>Actually, it looks like udev *is* the problem, but not because of
>partition tables.
you are right.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
