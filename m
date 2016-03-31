From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Raid 6 failing to assemble after machine power loss now, with 1
 disk only failed, seems to think its a raid0 array
Date: Thu, 31 Mar 2016 18:01:05 +1100
Message-ID: <56FCCB31.6050705@websitemanagers.com.au>
References: <CAAgcXJEgLxSaa7x3YO=CuMXS9hPPfPMiUtebQ4RB4F6dmQPd1g@mail.gmail.com>
 <56FC5060.4020502@turmel.org>
 <CAAgcXJFm=c8kGBrvnoHYOTmpV42_gb+0yRvSNN7p-U-Q7Y_OCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAgcXJFm=c8kGBrvnoHYOTmpV42_gb+0yRvSNN7p-U-Q7Y_OCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Knight <madcornishprojectionist@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Try the following:
mdadm --stop /dev/md126

Check /proc/mdstat and make sure there is nothing there
Check dmesg output and note the last line, you will need to paste 
everything after this line into your next email
madam --assemble /dev/md126 /dev/sd[abcdef]1
Adjust the devices listed above as applicable

Post the output of the above command, the dmesg output, and also 
/proc/mdstat afterwards.

You can also try stopping the array/clearing it again, and then try 
adding --force to the above command. Make sure to post the results.

Regards,
Adam

On 31/03/2016 17:09, Peter Knight wrote:
> Thank you for the reply Phil.
>
> Unfortunately that didn't work, I get the following message:
>
>
> root@Wheal-Peevor:~# mdadm --run /dev/md126
> mdadm: failed to start array /dev/md126: Input/output error
>
>
> Thanks
>
> Peter
>
> On 30 March 2016 at 23:17, Phil Turmel <philip@turmel.org> wrote:
>> On 03/30/2016 05:19 PM, Peter Knight wrote:
>>> Hi,
>>>
>>> I hope someone can explain what is going on and hopefully help me
>>> recover my data.
>>> What is causing this? and how can I get it reassembled so I can read the data?
>> When mdadm assembles an array during boot that has fewer devices than
>> when it was last shut down (cleanly), it generally declines to start it.
>>
>> Probably, all you need is:
>>
>> mdadm --run /dev/md126
>>
>> { --detail may not be accurate on an inactive device.  The member
>> --examine data is trustworthy. }
>>
>> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

