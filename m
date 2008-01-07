From: Jim <jim@fayettedigital.com>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Mon, 07 Jan 2008 09:46:30 -0500
Message-ID: <47823B46.6010105@fayettedigital.com>
References: <477FAAAC.2090107@fayettedigital.com> <18305.22361.482483.331552@notabene.brown>
Reply-To: jim@fayettedigital.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18305.22361.482483.331552@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday January 5, jim@fayettedigital.com wrote:
>   
>> root@chinaberry:~# mdadm /dev/md0 --add /dev/hdb5
>> mdadm: Cannot open /dev/hdb5: Device or resource busy
>>
>> All the solutions I've been able to google fail with the busy.  There is 
>> nothing that I can find that might be  using /dev/hdb5 except the raid 
>> device and it appears it's not either.
>>     
>
> Very odd. But something must be using it.
>
> What does
>    ls -l /sys/block/hdb/hdb5/holders
> show?
> What about
>    cat /proc/mounts
>    cat /proc/swaps
>    lsof /dev/hdb5
>   
> ??
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
Problem is not raid, or at least not obviously raid related.  The 
problem is that the whole disk, /dev/hdb is unavailable. 

root@chinaberry:~# for i in /dev/hdb?
 > do
 > mount $i /mnt
 > done
mount: /dev/hdb1 already mounted or /mnt busy
mount: /dev/hdb2 already mounted or /mnt busy
mount: /dev/hdb3 already mounted or /mnt busy
mount: /dev/hdb4 already mounted or /mnt busy
mount: /dev/hdb5 already mounted or /mnt busy
mount: /dev/hdb6 already mounted or /mnt busy
root@chinaberry:~# mount /dev/hda1 /mnt

I can fdisk it but none of the partitons are available. Knoppix can 
access it normally so it's not a hardware issue.  No funny messages in 
the syslog. So I'll go off and stop harassing this list.  ;)

Thanks,
Jim.
