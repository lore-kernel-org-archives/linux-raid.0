From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: How to update homehost of an existing raid component
Date: Mon, 19 Mar 2012 22:37:17 +0100
Message-ID: <4F67A70D.1020301@ivitera.com>
References: <4F670361.6090902@ivitera.com> <20120320082828.0937662d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120320082828.0937662d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Dne 19.3.2012 22:28, NeilBrown napsal(a):
> On Mon, 19 Mar 2012 10:58:57 +0100 Pavel Hofman <pavel.hofman@ivitera.com>
> wrote:
> 
>> Hi,
>>
>> Please is there a way to update a homehost value for a specific raid
>> component?
>>
>> md7 is raid1 composed of md5 and md6. UUID of md7 is listed in mdadm.conf:
>>
>> ARRAY /dev/md7 level=raid1 num-devices=2 metadata=01.00
>> UUID=dde16cd5:2e17c743:fcc7926c:fcf5081e
>>
>>
>> Every time I reboot, md7 is auto assembled only from md5. When running
>> manually, I get
>>
>> mdadm  --verbose -A /dev/md7  --scan
>> ...
>> mdadm: /dev/md6 misses out due to wrong homehost
>> ...
>>
> 
> There is something very strange here.
> md5 and md6 look to some extent like different parts of the same RAID1.
> They have the same Array UUID, the same "Update Time" and the same "Events"
> counter.
> However they have different "Creation Time" (19/Jan/2011 vs 17/Jun/2010) and
> different names ("orfeus:7" vs "'orpheus':7").
> 
> I cannot imagine how that would happen.
> 
> mdadm notices they are different so it cannot use them both.  It chooses md5
> over md6 as md5 has the 'correct' homehost name.
> 
> Your best bet would be to re-create the array so it gets good clean metadata.
> 
> mdadm -S /dev/md7
> mdadm -C /dev/md7 -l1 -n2 --assume-clean --metadata=1.0 /dev/md6 /dev/md5
> 
> should do it.  If you want to keep the same uuid, add
>    --uuid=dde16cd5:2e17c743:fcc7926c:fcf5081e
> 

Neil, thanks a lot for your help. The command worked fine, now both md5
and md6 have the same name.

Regards,

Pavel.
