From: "Tomas France" <tomfra@centrum.cz>
Subject: Re: Is it possible to grow a RAID-10 array with mdadm?
Date: Mon, 30 Jul 2007 12:24:03 +0200
Message-ID: <0e3e01c7d293$d85086d0$332317ac@Cortex>
References: <loom.20070727T225545-192@post.gmane.org><46ABAC5A.2000103@ziu.info><46ABB830.1000204@ziu.info><0dc901c7d20b$be23d100$332317ac@Cortex> <18093.42484.733479.935581@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the answer Neil!

>> The man page for mdadm does not mention it because it is not supported. 
>> <<

It doesn't actually even mention the possibility to create a RAID-10 array 
(without creating RAID-0 on top of RAID-1 pairs), yet from the info I found, 
a lot of people have been using it for quite a while. Almost as if it was a 
complete secret ;) As for the RAID-10 growing / layout change - I'd 
absolutely love to see that implemented in the (hopefully near) future. 
IMHO, RAID-10 is becoming very popular because of the falling hard drive 
prices.

Tomas


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "Tomas France" <tomfra@centrum.cz>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, July 30, 2007 10:48 AM
Subject: Re: Is it possible to grow a RAID-10 array with mdadm?


> On Sunday July 29, tomfra@centrum.cz wrote:
>> Hi everyone,
>>
>> Is it possible to add drives to an active RAID-10 array, using the "grow"
>> switch with mdadm, just like it is possible with a RAID-5 array? Or 
>> perhaps
>> there is another way?
>>
>> I have been looking for this information for a long time but have been
>> unable to find it anywhere. The man page for mdadm does not mention 
>> RAID-10
>> at all so that didn't help either. Has anyone tried it?
>
> The man page for mdadm does not mention it because it is not
> supported.
>
> There are several reshape options that I would like to implement
> including
>  - raid5 -> raid6
>  - shrinking raid4/5/6
>  - raid0 -> raid5
>  - changing chunksize/layout of raid4/5/6
>  - raid10 growing and layout change
>
> unfortunately I haven't yet found/made the time.
>
> Patches are always welcome :-)
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> 

