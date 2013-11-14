From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: mdadm --fail requires writeable drive.
Date: Thu, 14 Nov 2013 17:33:01 +0000
Message-ID: <5285094D.9070904@mpstor.com>
References: <52836DD1.8080605@mpstor.com> <20131114114449.27f3c746@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131114114449.27f3c746@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

This does work but I was looking for a way to explicitely set a 
particular device as Failed (I want to process devices one by one).

But right now I was reading from the array to force it detecting the 
failure as opposed to using "detached" which orders of magnitude better.

Thanks for the tip, I'll use that for now.

Regards,
Ben.

On 14/11/13 00:44, NeilBrown wrote:
> On Wed, 13 Nov 2013 12:17:21 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:
>
>> Hi,
>>
>> I noticed that mdadm --fail will only work if a disk is present and is
>> writeable.
>>
>> mdadm's Manage.c seems to first make sure the drive can be "stat"ed
>> before proceeding (which will fail if the drive is gone), and then
>> seemingly try to write "Faulty" to the drive's superblock as well as
>> notifying MD of the drive failure.
>>
>> However, in many cases, a drive must be set faulty because it has gone
>> offline. MD will do a very good job to set the drive faulty itself,
>> provided that IOs are running on the array. If no IOs are running on the
>> array, removing a drive and then trying to set it as failed will not
>> work. Trying to "-r" the drive will also fail since the drive is not yet
>> marked as failed, so deemed still in use.
>>
>> Looking through the code it seemed to me that MD could be told to fail a
>> drive even if that drive was no longer present (the /dev/sdX device node
>> file still is in this case), in the same way as remove works. Would that
>> be possible? Am I missing something here?
>
> Does
>    mdadm /dev/mdXX --fail detached
>
> do what you want?
>
> NeilBrown
>

