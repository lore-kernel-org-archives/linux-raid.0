From: Brian Candler <b.candler@pobox.com>
Subject: Re: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Fri, 11 Oct 2013 14:03:02 +0100
Message-ID: <5257F706.8050708@pobox.com>
References: <5253F7C2.2030401@pobox.com> <52541473.4020005@pobox.com> <52545092.1040001@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52545092.1040001@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/10/2013 19:36, Martin Wilck wrote:
> On 10/08/2013 04:19 PM, Brian Candler wrote:
>>   > Anyway, I'm not so worried about having broken this machine, as it
>> needed a reinstall anyway, but I do wonder what would have been the
>> correct way to get mdraid instead of dmraid at boot time for this root
>> volume?
>>
>> After some more searching, it looks like the udev rules were nobbled to
>> disable this in
>> https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1030292
>>
>> A possible way to re-enable is here:
>> https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1054948/comments/9
>>
>> I'm a bit concerned about the issues around clean shutdown, and hence
>> whether is really production-ready yet.
> In general, this works. I have seen it work with CentOS, Fedora, and
> various SUSE distributions.
FWIW, I found problems on stock CentOS 6.4.

I had created two RAID volumes within the BIOS:
"BOOT" (4GB)
"LVM" (rest of disk)

These are correctly detected and come up as md0 (container), md125 
(BOOT), md126 (LVM). In a previous install using Debian I had set these 
up as ext4 and LVM respectively.

In the CentOS graphical installer, they are shown as:

V Hard Drives
     md125    4096    ext4
     md126    902246 vg   Physical volume (LVM)

(md0 is not shown)

Problem: if I double-click on md125, or select md125 and click Edit..., 
nothing happens. Therefore I cannot mark it as being used for the /boot 
filesystem.

However, if I double-click on md126, it correctly pops up "You cannot 
edit this drive: This device is part of the LVM volume group 'vg'."

Then if I delete all the logical volumes, and the volume group, I 
expected to be able to edit md126 - but I can't. Again, just nothing 
happens when I double-click on it. I can neither partition it, nor 
change it to ext4 and mount it.

So it looks like there's work remaining to make this usable in CentOS too.

Regards,

Brian.

