From: David Greaves <david@dgreaves.com>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
     Linux
Date: Sat, 05 Jun 2004 07:36:00 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C169D0.2000600@dgreaves.com>
References: <200406041421.i54EL7319045@watkins-home.com> <006301c44aab$c02cc8c0$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006301c44aab$c02cc8c0$6705a8c0@a30>
To: me@heyjay.com
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can see why you said that.

my reading is that --auto *creates the major/minor numbers* by which the 
kernel recognises partitions.
It doesn't create the partitions.

I don't have an hdg, but if I did its partitions would be addressed like so:
david@ash:~$ ll /dev/hdg3
brw-rw----    1 root     disk      34,   3 Apr 15  2001 /dev/hdg3

I'd still need cfdisk et al to set the start/end blocks for the device.

Maybe:

--auto=partition creates the device files for partitions on the array 
which may then be manipulated as normal by cfdisk et al

would be a good --help entry?

David

me@heyjay.com wrote:

>I did finish, but the example seemed to show that the --auto would build the
>partitions.  I know at the end of the message Neil said then you use cfdisk
>but it seemed unnecessary at that point
>
>Jay
>----- Original Message ----- 
>From: "Guy" <bugzilla@watkins-home.com>
>To: <me@heyjay.com>; <linux-raid@vger.kernel.org>
>Sent: Friday, June 04, 2004 9:21 AM
>Subject: RE: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
>Linux
>
>
>  
>
>>You must finish reading what Neil said!
>>
>>< Then
>><    cfdisk /dev/md/XX
>>< will allow you to partition the array.
>>
>>He has more info you somehow skipped!
>>Re-read the email from Neil.
>>
>>
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org
>>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of me@heyjay.com
>>Sent: Friday, June 04, 2004 9:31 AM
>>To: Neil Brown; linux-raid@vger.kernel.org
>>Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
>>Linux
>>
>>    
>>
>>>The simplest way to access this functionality is with
>>>
>>>    mdadm --create /dev/md/XX --auto=partition --level= ....
>>>
>>>      
>>>
>>How does in know how big to build the partitions?
>>How does it know how many partitions?
>>
>>Can you do it with out building the partitions automatically
>>and instead it will just build /dev/mdXX and then I can use
>>fdisk, sdisk, cfdisk... to build my partitions?
>>
>>Thanks
>>Jay
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>    
>>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

