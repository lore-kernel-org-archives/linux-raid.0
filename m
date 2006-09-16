From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: proactive-raid-disk-replacement
Date: Sat, 16 Sep 2006 10:28:57 -0400
Message-ID: <450C0A29.10606@tmr.com>
References: <45012E73.5040900@tls.msk.ru>	 <20060910020203.27d26886@30_bodo.rupinet> <5b170a7d0609100353n60dcb57drd38aabad4a0081a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0609100353n60dcb57drd38aabad4a0081a4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tuomas Leikola <tuomas.leikola@gmail.com>
Cc: Bodo Thiesen <bothie@gmx.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tuomas Leikola wrote:

> On 9/10/06, Bodo Thiesen <bothie@gmx.de> wrote:
>
>> So, we need a way, to feedback the redundancy from the raid5 to the 
>> raid1.
>
> <snip long explanation>
>
> Sounds awfully complicated to me. Perhaps this is how it internally
> works, but my 2 cents go to the option to gracefully remove a device
> (migrating to a spare without losing redundancy) in the kernel (or
> mdadm).
>
> I'm thinking
>
> mdadm /dev/raid-device -a /dev/new-disk
> mdadm /dev/raid-device --graceful-remove /dev/failing-disk
>
> also hopefully a path to do this instead of kicking (multiple) disks
> when bad blocks occur. 


Actually, an internal implementation is really needed if this is to be 
generally useful to a non-guru. And it has other possible uses, as well. 
if there were just a --migrate command:
  mdadm --migrate /dev/md0 /dev/sda /dev/sdf
as an example for discussion, the whole process of not only moving the 
data, but getting recovered information from the RAID array could be 
done by software which does the right thing, creating superblocks, copy 
UUID, etc. And as a last step it could invalidate the superblock on the 
failing drive (so reboots would work right) and leave the array running 
on the new drive.

But wait, there's more! Assume that I want to upgrade from a set of 
250GB drives to 400GB drives. Using this feature I could replace a drive 
at a time, then --grow the array. The process for doing that is complex 
currently, and many manual steps invite errors.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

