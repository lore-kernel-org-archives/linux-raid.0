From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Reshaping the length of devices
Date: Fri, 12 Mar 2010 07:18:17 -0800 (PST)
Message-ID: <678411.30301.qm@web51307.mail.re2.yahoo.com>
References: <4B9A5A7B.4070105@shiftmail.org>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9A5A7B.4070105@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Asdo <asdo@shiftmail.org>
List-Id: linux-raid.ids




--- On Fri, 12/3/10, Asdo <asdo@shiftmail.org> wrote:

> From: Asdo <asdo@shiftmail.org>
> Subject: Reshaping the length of devices
> To: "linux-raid" <linux-raid@vger.kernel.org>
> Date: Friday, 12 March, 2010, 15:15
> I am wondering... is it possible to
> reshape the length of the underlying devices with MD raid?
> 
> I mean like in the case one buys larger disks: after moving
> the raid partitions to the new disks half of them is still
> free. So one might want to extend the raid partitions to the
> end of the disks instead of creating another array in the
> free space.
> 
> I have searched the linux-raid mailing list history but I
> couldn't find this topic.
> 
> Thanks in advance

As long as the size of ALL underlying devices have increased you can --grow=MAX to the a multiple of the now smallest drive.

From:

http://linux.die.net/man/8/mdadm

This value can be set with --grow for RAID level 1/4/5/6. If the array was created with a size smaller than the currently active drives, the extra space can be accessed using --grow. The size can be given as max  which means to choose the largest size that fits on all current drives. 


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing it with jon AT eHardcastle.com
***********

-----------------------


      
