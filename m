From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: musical chairs
Date: Thu, 23 Sep 2004 03:47:15 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41520F03.1050502@tls.msk.ru>
References: <001501c4a0d6$7818e740$7000a8c0@gordo> <1095887821.4196.1530.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1095887821.4196.1530.camel@compaq.xsintricity.com>
Cc: dr_snafu <dr_snafu@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Wed, 2004-09-22 at 15:00, dr_snafu wrote:
> 
>>hello, 
>>
>>i have a disk with data on it /dev/hdc, 
>>    and a brand new empty disk /dev/hdb. 
> 
> Partitions not in use?
> 
> 
>>want to set up raid 1 without moving data off hdc. 
>>    it very large and i have no where to put it
>>
>>will this work?: (notice # of devices)
>>
>>mdadm --create --verbose /dev/md0 --level=1 
>>        --raid-devices=1  /dev/hdb

When creating raid array, you have to set number
of devices correctly in the first place -- there's
no way - not in current versions of the tools and
kernel code anyway - to "grow" the array after
it will be created.  You have to create "degraded"
array first, like this:

  mdadm --create /dev/md0 --level=1
    --raid-devices=2 /dev/hdb missing

(the word "missing" is really that - missing, literally).

>>will this create an unmirrored raid 1 setup? 

Not "unmirrored", but degraded - it will be ok
when you'll add the missing disc to it later.

>>    can i start and mount md0?
>>    then copy the data from hdb to md0?

yes.

>>then?:
>>
>>mdadm /dev/md0 --add /dev/hdc

Yes -- it will work with degraded array created
as above.  Do note however that disk sizes should
be the same, or hdc should be larger -- if it is
smaller, you may not get correct results here, for
obvious reasons.  For this too, making partitions
instead of using whole unpartitioned drives may
help -- even disks are different in size, you may
create partitions of equal size on both.

>>
>>seems too good to be true, 
>>    maybe you know another way?
> 
> Use e2fsresize or whatever it's called to shrink the size of the e2fs on
> /dev/hdc by 64k, then mdadm -C /dev/md0 -l raid1 -n 2 /dev/hdc failed,
> then mdadm /dev/md0 -a /dev/hdb and all the data will then be synced
> from hdc to hdb and when it's done the raid array will be up, running,
> and fully operational.

I'd say this way is somewhat more risky.  Yes, there will be only one
data copy operation, from hdc to hdb.  But if anything goes bad, the
data may be lost.  This is why it is suggested to do backup before any
filesystem-related changes, but since there's no place to save the
data to, creating array first, copying data to it and adding the
missing (old) disk -- this way you'll always have two copies of
the data, up to the moment when you're adding second disk to the
array (when it will gets owerwritten from the first - new - disk),
and there will be no place when your data will be modified in-place
(most dangerous), as ext2resize does.  Ext2resize believed to be
stable, however...

/mjt
