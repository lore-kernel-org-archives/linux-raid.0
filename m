From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 09:20:25 -0400
Message-ID: <4BCEFB99.9080806@tmr.com>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCC65EB.3080803@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phillip Susi wrote:
> On 4/14/2010 3:53 PM, Bill Davidsen wrote:
>   
>> Stefan *St0fF* Huebner wrote:
>>     
>>> Am 25.03.2010 18:45, schrieb Asdo:
>>>  
>>>       
>>>> David Lethe wrote:
>>>>    
>>>>         
>>>>> On Mar 25, 2010, at 11:20 AM, Andrew Dunn wrote:
>>>>>  
>>>>>      
>>>>>           
>>>>>> Recently Dell is selling their WD20EARS (2TB) for 90$
>>>>>>
>>>>>> This being one of the best PPG (Price Per Gigabyte) snatches I have
>>>>>> seen, I was considering buying 8 of them for an mdadm array.
>>>>>>
>>>>>> Has anyone had experience with these drives?
>>>>>>             
>
> I believe that these disks only come in the "green" variety.  I recently
> picked up a 1.5 tb version for testing and cheap bulk storage, and I
> would not suggest using them in a raid array because the green drives
> firmware automatically parks the head after 8 seconds of inactivity and
> reduces the rpm of the disk.  The constant parking can quickly wear out
> the head under high use and there is no way to disable this "feature".
>   

I hear this said, but I don't have any data to back it up. Drive vendors 
aren't stupid, so if the parking feature is likely to cause premature 
failures under warranty, I would expect that the feature would not be 
there, or that the drive would be made more robust. Maybe I have too 
much faith in greed as a design goal, but I have to wonder if load 
cycles are as destructive as seems to be the assumption.

I'd love to find some real data, anecdotal stories about older drives 
are not overly helpful. Clearly there is a trade-off between energy 
saving, response, and durability, I just don't have any data from a 
large population of new (green) drives.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

