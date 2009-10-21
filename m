From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Disappointing RAID10 Performance
Date: Wed, 21 Oct 2009 19:26:14 -0400
Message-ID: <4ADF9896.6090201@tmr.com>
References: <715541.19877.qm@web38803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <715541.19877.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

adfas asd wrote:
> --- On Fri, 10/16/09, Rob Becker <Rob.Becker@riverbed.com> wrote:
>   
>>    What command did you use to create your
>> raid-10?
>>     
>
> /
> mdadm --create /dev/md0 --level=raid1 --chunk=256 --raid-disks=2 missing /dev/sdb1
> swap
> mdadm --create /dev/md1 --level=raid10 --layout=o2 --chunk=256 --raid-disks=2 missing /dev/sdb2
> /home
> mdadm --create /dev/md2 --level=raid10 --layout=o2 --chunk=1024 --raid-disks=2 missing /dev/sdb3
> ... then copied files and later added the sda parts to the array. (RAID conversion on live system)
>
>   
No wonder it's slow, you want two far copies, this is more or less 
mirroring with only two drives. Using a large buffer size also helps, 
you hurt your performance by limiting readahead. You can also use the 
'blockdev' command (--setra) to increase your readahead on the array. 
Just going to far should about double your speed, the other things may 
help more.
>   
>>  You might try  
>> running iostat in parallel to see if the read_balancer is
>> properly  
>> balancing the reads between the two disks.
>>     
>
> Don't understand this as I'm a bit of a n00b...
>
>
> --- On Fri, 10/16/09, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>   
>> If you only use your RAID-10 array for a single "dd
>> if=bigfile of=/dev/null" then yes, it does not give you much
>> over mirroring.
>>
>> If you start using your drives for two "dd if=bigfile[12]
>> of=/dev/null" at the same time, you will notice the
>> difference.
>>     
>
> OK so it was a fallacy to think this would help with large files, unless more than one is involved.
>   

You are misconfigured.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

