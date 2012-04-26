From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Removing a failing drive from multiple arrays
Date: Thu, 26 Apr 2012 08:59:01 -0400
Message-ID: <4F994695.9010509@tmr.com>
References: <4F905F66.6070803@tmr.com> <20369.29756.761374.308057@quad.stoffel.home> <4F918F5C.2000607@anonymous.org.uk> <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com> <4F9450D1.40305@anonymous.org.uk> <4F98B4FE.5010101@tmr.com> <20120426073607.GA11590@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120426073607.GA11590@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brian Candler wrote:
> On Wed, Apr 25, 2012 at 10:37:50PM -0400, Bill Davidsen wrote:
>> I have put MBR and boot partition on a USB thumb drive because the
>> failure rate of a R/O flash is lower than rotating devices (in my
>> experience). Use ext2 for boot, no journal so the drive works really
>> read-only. Hopefully grub2 mounts the boot noatime.
> Another option, although I've not done this for a long time, is PXE boot.
> You need a DHCP server giving out the correct parameters and a TFTP server
> for the kernel (and ramdisk?)
>

I think that's addressing one point of failure while adding more. The network 
(as a collection of single points of failure), the server(s), all seem to go in 
the "must work" category. Adding stuff in parallel is good, if one works the 
process works, in series is bad, if one fails the process fails.

Like many people I'm trying for five star reliability on a three star budget. I 
do have redundant servers and storage, I lack up to the last transaction file 
duplication. And as I found last year, my firewall and DNS have a backup, but 
it's on a shelf, not running in parallel. That's on my list of things to do this 
summer.

Thanks for the thought, that would be a great install option, wouldn't it?

-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



