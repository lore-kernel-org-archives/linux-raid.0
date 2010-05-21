From: MRK <mrk@shiftmail.org>
Subject: Re: raid 5 mismatch_cnt errors
Date: Fri, 21 May 2010 18:40:34 +0200
Message-ID: <4BF6B782.3060408@shiftmail.org>
References: <4BF56B1F.9080205@locallinux.com>
 <20100521071645.497cdcad@notabene.brown> <4BF5B7D1.3070808@locallinux.com>
 <20100521083819.54680dfb@notabene.brown> <4BF5ECE7.7020907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4BF5ECE7.7020907@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Trey Scarborough <treys@locallinux.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/21/2010 04:16 AM, Doug Ledford wrote:
> On 05/20/2010 06:38 PM, Neil Brown wrote:
>    
>> On Thu, 20 May 2010 17:29:37 -0500
>> Trey Scarborough<treys@locallinux.com>  wrote:
>>
>>      
>>> Neil Brown wrote:
>>>        
>>>> On Thu, 20 May 2010 12:02:23 -0500
>>>> Trey Scarborough<treys@locallinux.com>  wrote:
>>>>
>>>>
>>>>          
>>>>> I have a raid 5 array with 9 disks and I have a mismatch_cnt that keeps
>>>>> growing. This is causing file corruption on the underlaying file systems
>>>>> as well.  I can copy a group of 100 100mb files and then do a md5sum on
>>>>> them and 1-3 will be corrupt. If this is a drive that is bad is there
>>>>> anyway to run a report on the count per drive that these mismatches
>>>>> occur. I have run smarttools test and do not see one drive that stands
>>>>> out to be causing errors. Could something else be causing these errors?
>>>>>
>>>>>            
> While a bad drive is certainly a possibility here, this is precisely the
> type of failure scenario that would make me suspect bad RAM,
> motherboard, or CPU.  So I wouldn't rule those out as possibilities either.
>    

Could the cabling to the drive be causing this? (maybe failing or maybe 
it's partly disconnected)
I don't remember at what point Linux is at implementing the checksums 
between the controller and the drive.
