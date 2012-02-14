From: Joe Landman <joe.landman@gmail.com>
Subject: Re: SES Enclosure Management.
Date: Tue, 14 Feb 2012 15:38:46 -0500
Message-ID: <4F3AC656.3050406@gmail.com>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Woodworth <robertjwoodworth@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/14/2012 12:30 PM, Robert Woodworth wrote:
> Has anyone ever thought of integrating SES managed enclosures into the
> kernel RAID system?  I briefly looked through the archives and have
> not found anything on the topic.
>
> Some HW based RAID controllers do this flawlessly now, there is no
> reason why the kernel RAID cannot also.  (LSI MegaRAID)
>
> 1) When a drive is part if a managed enclosure, the RAID system should
> address it by location instead of by enumerated device node.  The SES
> device in the enclosure can map the physical slot to a physical drive.
>   The RAID admin (mdamd) should be able to add/fail/identify devices
> based on slot.

We've got something like this going now, but the SES interface is 
usually through an HBA vendor specific cli tool.  Is there somewhere 
else we can/should look for SES bits?

>
> 2) If the RAID system fails a drive, it should notify the SES
> management and turn on the fail bit and the fail LED.

Agreed.  This said, we've found some backplanes that simply do not work 
correctly for SES or SGPIO modes.

>
> 3) The RAID system should be able to turn on the 'identify' bit and
> LEDs for an array or a single drive.
>
> I'm currently doing firmware on a managed enclosure.  Although my
> vendor only supports LSI MegaRAID, there is no reason why my
> enclosures cannot work in the same manner on a kernel RAID system.
>
>
>
> Request for comments...

If there are libraries we can hook into to light this up correctly, let 
me know.  We have some of the elements of this in place via a number of 
tools we've developed for our units.  But we rely upon an HBA vendor 
tool to communicate with the backplane.  Would certainly like to talk 
"directly" to the backplane.  Any hints on how to do this?



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

