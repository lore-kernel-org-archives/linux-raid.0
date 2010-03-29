From: Joachim Otahal <Jou@gmx.net>
Subject: Re: Swap on /dev/md1 always lost after reboot
Date: Mon, 29 Mar 2010 19:32:29 +0200
Message-ID: <4BB0E42D.8030406@gmx.net>
References: <4BB00EBF.7070304@gmx.net> <4BB01158.6050109@gmx.net> <4877c76c1003282333j7250a117y4dcff2aa12f75e9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003282333j7250a117y4dcff2aa12f75e9b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans schrieb:
> On Sun, Mar 28, 2010 at 7:32 PM, Joachim Otahal<Jou@gmx.net>  wrote:
>    
>> Joachim Otahal schrieb:
>>      
>>> free says: swap active, mdstat says:
>>> md2 : active (auto-read-only) raid1 sda2[1] sdb2[0]
>>>       979840 blocks [2/2] [UU]
>>>        
>> minor correction: the output right after creating the raid + issuing a
>> mkswap is
>> md2 : active raid1 sda2[1] sdb2[0]
>>       979840 blocks [2/2] [UU]
>>       [=======>.............]  resync = 37.9% (372480/979840) finish=0.1min
>> speed=93120K/sec
>>
>> and a few second later:
>> md2 : active raid1 sda2[1] sdb2[0]
>>       979840 blocks [2/2] [UU]
>>
>> mdadm.conf updated, but md2 still not there after reboot.
>>
>> Joachim
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>      
> Trigger the regeneration of your initrd/initramfs image.  It's
> probably got an mdadm.conf that lacks your second device.
>
>    
Strike, thank you.

Joachim Otahal
