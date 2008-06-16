From: "michael@kmaclub.com" <michael@kmaclub.com>
Subject: Re: Confused about UUID mounting and mirrors
Date: Mon, 16 Jun 2008 14:29:48 -0700
Message-ID: <4856DB4C.20905@kmaclub.com>
References: <4856A8C6.3030609@kmaclub.com> <4856CFE1.1020105@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4856CFE1.1020105@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michal Soltys wrote:
> michael@kmaclub.com wrote:
>> Hello,
>>
>> This confuses mount at boot time.
>>
>> How to I get it to correctly find md0 and not the components of the 
>> mirror?
>>
> 
> You mean you mount by /dev/disk/by-uuid/* ?


In /etc/fstab,  I have entries like this:

UUID=8e651838-38c1-4783-8bde-4174ec484d52 /     ext3    defaults  1 1
UUID=aaeca70c-f0fe-470c-b631-87248648d275 /export xfs defaults,nobarrier 1 2
UUID=6e22c5b0-2874-4826-a871-ed733f8da643 swap swap    defaults   0 0
UUID=323cd094-4cbe-4c3b-9096-366c05465e7c /export/services xfs defaults 1 2

so it is referring to the UUID of the filesystem and not necessarily the 
device.  Some are single partitions, some md devices, and some sit on 
top of LVM.


> The 0.9x or 1.0 superblocks (the ones working nicely with grub and 
> raid1) are placed at the end of the device, thus existing filesystem can 
> be detected both from /dev/sd{a,b}1 and /dev/md0.
> 
> In such case, you will have to adjust udev rules, so sd{a,b}1 filesystem 
> uuid symlinks will not be created, or will be overwritten by the symlink 
> to /dev/md0.
> 
> You can achieve the latter with higher link_priority in OPTIONS, in your 
> udev rules.

Do you have an example?  I am not sure I follow.

So what happens if someone sticks in a USB key and boots the machine. 
The key bcomes sda, and each following drive shifts.  Is UDEV in this 
case going to know to account for this?  The goal is to be able to 
always find the filesystem regardless of what the disk name might be.

Michael
