From: Joe Landman <joe.landman@gmail.com>
Subject: Re: debian software raid1
Date: Tue, 19 Apr 2011 20:33:46 -0400
Message-ID: <4DAE29EA.4040306@gmail.com>
References: <1303215166.2809.8.camel@valio>	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>	<4DADB24F.2030300@cdf.toronto.edu> <20110420085148.12ac0002@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110420085148.12ac0002@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Iordan Iordanov <iordan@cdf.toronto.edu>, =?ISO-8859-1?Q?Mathias_Bu?= =?ISO-8859-1?Q?r=E9n?= <mathias.buren@gmail.com>, b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/19/2011 06:51 PM, NeilBrown wrote:
> On Tue, 19 Apr 2011 12:03:27 -0400 Iordan Iordanov<iordan@cdf.toronto.edu>

[...]

> If there was such a deadlock, it would be a serious bug.   I don't believe
> such a bug exists (but hey - I keep finding bugs in this code, when I'm not
> busy writing new bugs, so I guess it could crash you machine and kill your
> cat).

I ran into this a few years ago (early 2.6 series, maybe 2.6.15 or so). 
  Some sort of race condition.  Required a reset to get the machines 
attention.  Haven't tried since.  Since we do lots of MD raid, I 
generally either put the swap on hardware RAID, or stripe it and 
sometimes hope for the best.  The latter doesn't always work.  When a 
drive goes pear shaped, and takes down pages with it, your machine will 
crash, and pretty hard at that.

We'll definitely try the swap atop MD RAID going forward.  I like the 
idea of a RAID10 for it.

>> It would be nice to have a discussion among people who have experience
>> with all of this.
>
> Definitely put swap on RAID1 if you have RAID1 at all.
>
> My personal preference with RAID1 to to have a single RAID1 (probably
> --metadata=1.0) across the whole devices, and partition that for root, swap,
> home.

This gets to my question, since we haven't tried this yet ... can we do 
whole device MD RAIDs, and boot from them?  Is there anything special we 
need to do in their construction (use --auto=mdp or similar)?  We'd 
really prefer to go this route rather than building multiple smaller 
RAIDs.  We can manage the latter, but the former is far easier/cleaner 
to handle rebuilds with.

Regards,

Joe


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
