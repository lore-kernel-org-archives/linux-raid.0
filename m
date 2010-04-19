From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Mon, 19 Apr 2010 10:17:15 -0400
Message-ID: <4BCC65EB.3080803@cfl.rr.com>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BC61D47.6090403@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/14/2010 3:53 PM, Bill Davidsen wrote:
> Stefan *St0fF* Huebner wrote:
>> Am 25.03.2010 18:45, schrieb Asdo:
>>  
>>> David Lethe wrote:
>>>    
>>>> On Mar 25, 2010, at 11:20 AM, Andrew Dunn wrote:
>>>>  
>>>>      
>>>>> Recently Dell is selling their WD20EARS (2TB) for 90$
>>>>>
>>>>> This being one of the best PPG (Price Per Gigabyte) snatches I have
>>>>> seen, I was considering buying 8 of them for an mdadm array.
>>>>>
>>>>> Has anyone had experience with these drives?

I believe that these disks only come in the "green" variety.  I recently
picked up a 1.5 tb version for testing and cheap bulk storage, and I
would not suggest using them in a raid array because the green drives
firmware automatically parks the head after 8 seconds of inactivity and
reduces the rpm of the disk.  The constant parking can quickly wear out
the head under high use and there is no way to disable this "feature".
