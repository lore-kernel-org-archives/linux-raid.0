From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: Add a spare to raid5 array?
Date: Sat, 12 Mar 2005 08:22:57 +0800
Message-ID: <42323661.9000002@fastmail.co.uk>
References: <422FA1F8.4020709@advocap.org> <42320266.2040901@m-cam.com>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <42320266.2040901@m-cam.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently had cause to do this (I had to RMA my WD2000 which would only 
work as a slave device - see previous thread). I could just replace the 
disk since it was a PATA disk and the others I have are SATA.

It worked very nicely.

I am now wondering how this 'running with spare' state compares with the 
original state (using the, now missing, disk).

Is it the same now?

Max.

Arshavir Grigorian wrote:
> John McMonagle wrote:
> 
>> Can  a  spare be added to an existing raid 5 array?
>>
>> I do not see any way to do it.
>>
>> John
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> How about mdadm --add?
> 
> Arshavir
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
