From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: md device renaming
Date: Sun, 12 Dec 2010 19:54:08 -0700
Message-ID: <4D058AD0.7030704@feystorm.net>
References: <4D0586D1.2040501@feystorm.net> <20101213134920.70512086@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213134920.70512086@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sent: Sun Dec 12 2010 19:49:20 GMT-0700 (Mountain Standard Time)
From: Neil Brown <neilb@suse.de>
To: Patrick H. <linux-raid@feystorm.net> linux-raid@vger.kernel.org
Subject: Re: md device renaming
> On Sun, 12 Dec 2010 19:37:05 -0700 "Patrick H." <linux-raid@feystorm.net>
> wrote:
>
>   
>> So, every time I start up this md device with a specified name, it 
>> renames itself to something else.
>>
>> When I first created the array, I typo'd the name as 'nas01:isci-sdb1' 
>> (should be nas01:iscsi-sdb1). And now every time I assemble it with the 
>> correct name, it renames itself:
>>
>> # /sbin/mdadm -A /dev/md/nas01:iscsi-sdb1 --uuid 
>> abddf4ea:06524e68:8e2b8f4e:1b24c56d -R -U name
>> mdadm: /dev/md/nas01:iscsi-sdb1 has been started with 2 drives (out of 3)
>> # ls /dev/md/nas*
>> /dev/md/nas01:isci-sdb1
>> # ls /dev/disk/by-id/md-name*
>> /dev/disk/by-id/md-name-nas01:iscsi-sdb1
>> # mdadm -D /dev/md/nas01:isci-sdb1|grep Name
>>            Name : nas01:iscsi-sdb1  (local to host nas01)
>>
>>
>> So, notice how it says it started it as "nas01:iscsi-sdb1", however once 
>> its up and I do the `ls`, it has the original name on it. I've tried -U 
>> name to update the name on it when its assembled, but doesnt do a thing.
>>
>> Am I missing something here. Shouldnt it be assembling itself with the 
>> specified name I gave it, not the original name? And then how do I 
>> update it so the name in the metadata is correct?
>> (and yes I know its missing a drive, I'm testing some stuff out)
>>     
>
> It is assembling it with the name you give it, but the name stored in the
> metadata is still the old name.
> Try adding --update=name to the --assemble command.
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
How is it assembling with the name I gave it? It says 
"/dev/md/nas01:iscsi-sdb1 has been started", but it really is using 
"nas01:isci-sdb1". Even if it is going to use the name I created it 
with, it should say that instead of the name I provided on the assemble 
command.
And I did add the update argument, see the '-U name' option on the end 
of the command above.
