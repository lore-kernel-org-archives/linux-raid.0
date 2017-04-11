From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Shrinking an array
Date: Tue, 11 Apr 2017 11:05:25 +1000
Message-ID: <1f0601cb-f91d-0a1e-fc1d-5dd1c126a467@websitemanagers.com.au>
References: <20170411003008.GA18538@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170411003008.GA18538@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/04/17 10:30, Wakko Warner wrote:
> I have a question about shrinking an array.  My current array is 4x 2tb
> disks in raid6 (md0).  The array was created on the 2nd partition of each
> disk and spans most of the disk.  I would like to replace the 2tb disks with
> 750gb disks.  md0 is a luks container with lvm underneath.  I have less than
> 1tb actually in use.  What would the recommended procedure be for shrinking
> this?  I've watched this list, but I don't think I've come across anyone
> actually wanting to do this before.
> I'm thinking of these steps already:
> 1) Shrink PV.
> 2) Shrink luks.  I'm aware that there is not size metadata, but the dm
> mapping would need to be shrunk.
> 3) Shrink md0.  I did this once when I changed a 6 drive raid6 into a 5
> drive raid6.  Would I use --array-size= or --size= ?  I understand the
> difference is the size of md0 vs the individual members.
>
> So for number 4, if md0 is now small enough, will it accept a member that is
> smaller?  If so, I should beable to add the member to the array and issue
> --replace.
>
> Thanks.
>
I think the order is wrong.... or I mis-understood the layering. You 
need to shrink the highest layer first and work down the stack, for LVM 
on luks on RAID it would be something like this:
1) Reduce the filesystem size
2) Reduce the LV size
3) Reduce the PV size
4) Reduce the luks size
5) Reduce the RAID (mdadm) size
6) Replace the physical devices with smaller ones (or reduce the 
partition size/etc as needed)

I generally reduce my each one with a decent margin, and then when I'm 
finished, I increase each one to fill the available space (after the 
physical device size is changed). This avoids issues with accidentally 
trimming too much and then losing data/corrupting data. You should also 
verify that all your data is accessible after each step, most steps are 
reversible if you identify the issue quickly enough (at least with 
simple stacks when changing partition size, LVM and/or luks might 
complicate that).

Regards,
Adam



-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
