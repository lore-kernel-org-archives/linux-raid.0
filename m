From: George Huber <huber_geo@hotmail.com>
Subject: Re: Problems setting up RAID1
Date: Wed, 18 May 2005 16:32:54 -0400
Message-ID: <d6g8np$vr9$1@sea.gmane.org>
References: <d6danj$nmr$1@sea.gmane.org> <slrnd8n1vj.na8.noll@p133.mathematik.tu-darmstadt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnd8n1vj.na8.noll@p133.mathematik.tu-darmstadt.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> On Tue, 17 May 2005 13:48:21 -0400 you wrote in local.lists.linux-raid:
> 
>>I am having problems setting up RAID 1 using Fedora core 3.  Here are
>>the steps that I have taken to date.
> 
> 
> [...]
> 
> 
> 
>>    Note: I was able to execute the command:
>>    mount / -o remount,rw
> 
> 
> That command should be the first thing to to after fscking /. Usually it
> is run from a bootup script.
> 

Agreed, however it appears that the system is not doing this from a 
start up script due to the large numbers of error messages regarding a 
read-only file system.  I tried this from a command prompt in the hope
that it would give me an error message that I could use in 
trouble-shooting but it worked normally.
> 
>>Any suggestiong on what I should try next.
> 
> 
> Did you try root=/dev/md7 in your lilo.conf (or at the lilo prompt)?
> 
Fedora core 3 used GRUB as the boot loader (part of my problem may be 
that all of the how-to's that I have found still deal with lilo).  The
only options for a boot loader with Fedora core 3 are 'GRUB' and not to
install a boot loader.  Any tips on using GRUB with RAID

> And please check you have the correct rootfs entry in your /etc/fstab.

Verified.

Thanks,
George

