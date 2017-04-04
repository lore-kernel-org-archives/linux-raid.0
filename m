From: Zhilong <zlliu@suse.com>
Subject: Re: [PATCH v1] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Tue, 4 Apr 2017 13:07:45 +0800
Message-ID: <5B908F2B-D84A-4C4E-A0C6-863B6E793D75@suse.com>
References: <wrfjk27aid6n.fsf@gmail.com> <20170330073808.6176-1-zlliu@suse.com> <87d1cukszu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1cukszu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Send from iPhone

> 在 2017年4月3日，12:36，NeilBrown <neilb@suse.com> 写道：
> 
>> On Thu, Mar 30 2017, Zhilong Liu wrote:
>> 
>> systemctl doesn't interpret mdadm-grow-continue@.service
>> correctly due to the wrong argument provided in [service],
>> it should be corrected %I as %i. Otherwise, if the service
>> cannot start by systemctl and the reshap progress would be
>> stuck all time when grows array from raid1 to raid5.
>> 
>> reproduce steps:
>> ./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
>> ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>> 
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>> systemd/mdadm-grow-continue@.service | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
>> index 5c667d2..882bc0b 100644
>> --- a/systemd/mdadm-grow-continue@.service
>> +++ b/systemd/mdadm-grow-continue@.service
>> @@ -10,7 +10,7 @@ Description=Manage MD Reshape on /dev/%I
>> DefaultDependencies=no
>> 
>> [Service]
>> -ExecStart=BINDIR/mdadm --grow --continue /dev/%I
>> +ExecStart=BINDIR/mdadm --grow --continue /dev/%i
> 
> Do you know why this makes a difference?  I don't think it should.
> man systemd.unit says that "%i" is the "Instance name" while "%I" is the
> "Unescaped instance name".
> 
> The Instance name here is something like "md0" so there is nothing to
> escape.
> 
> I would rather not change it unless we know exactly why it is broken,
> and I don't find your explanation to be convincing.
> 

Exactly, you're correct, in this case, %i and %I are the same. The root cause is the ExecStart part, all the path name should be verified by systemd-escape，such as:
/sbin/mdadm should be corrected as sbin-mdadm, and /dev/%I should be -dev-%I. Thus I'm sorry for this patch, I do agree with you not to change it. And say sorry to Jes.

Thanks 
-zhilong 

> NeilBrown
> 
> 
>> StandardInput=null
>> StandardOutput=null
>> StandardError=null
>> -- 
>> 2.10.2
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

