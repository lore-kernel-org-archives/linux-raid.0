From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Is this likely to cause me problems?
Date: Wed, 22 Sep 2010 07:38:13 -0700 (PDT)
Message-ID: <965225.13513.qm@web51302.mail.re2.yahoo.com>
References: <4C99E7AF.4090503@anonymous.org.uk>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C99E7AF.4090503@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 22/9/10, John Robinson <john.robinson@anonymous.org.uk> wrote:

> From: John Robinson <john.robinson@anonymous.org.uk>
> Subject: Re: Is this likely to cause me problems?
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Wednesday, 22 September, 2010, 12:25
> On 22/09/2010 07:42, Jon Hardcastle
> wrote:
> [...]
> > So do you have any recommendations? I would like to
> 'trust' the new version of fdisk but I can not risk
> torpedoing myself. I have 2 more drives I need to 'phase
> out' at some point; but they will liklely be with 1.5TB
> drives.
> 
> The new layout you've got is meant for SSDs and drives with
> 4K sectors; the old layout is fine for you.
> 
> > My gut tells me that i should whilst I have other
> drives the same size use the same paratermeters... then when
> i have a bigger drive that is definately not going to cause
> any size issues let fdisk do its magic.
> > 
> > So following that premsis is there any down side to
> copy the partition table off another drive?
> 
> I can't think of one. For backup, if I remember correctly
> Doug Ledford's hot-swap auto-rebuilding onto virgin drives
> work was going to create partition tables by copying them
> from existing drives (or by having the user copy the
> required partition table from a drive in advance).
> 
> Cheers,
> 
> John.
> 

Hi,

Thanks for your help. I have been doing some background reading and am concinving myself to leave the boundaries as they are as it appears there is performance gains to be had? Assuming this is true as long as the parition size is LARGER than the other 1TB paritions I should be ok, right?

Device Boot         Start  End          Blocks
/dev/sda1              63  1953520064   976760001
/dev/sdc1            2048  1953525167   976761560

If i subtract Start from End
sda = 1953520064 - 63   = 1953520001
sdc = 1953525167 - 2048 = 1953523119 (3118 larger than sda)

as long as sdc is larger which it is by 3118 I should be ok right?

I am even thinking about individually removeing my drives from the array and letting fdisk use its new calculations for the existing drives. I could do with better performance!


      
