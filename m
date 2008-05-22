From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Thu, 22 May 2008 10:42:35 -0400
Message-ID: <4835865B.4000501@gmail.com>
References: <122201c8bad9$0050f26a$3501a8c0@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <122201c8bad9$0050f26a$3501a8c0@exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David@santools.com
Cc: Keith Roberts <keith@karsites.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
> the disk manufacturers stopped making them last year, and stopped R&D on them way before that.  
>
> -----Original Message-----
>
> From:  "Keith Roberts" <keith@karsites.net>
> Subj:  RE:  Re:  Re: Two Drive Failure on RAID-5
> Date:  Tue May 20, 2008 5:20 pm
> Size:  1K
> To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
>
> On Tue, 20 May 2008, David Lethe wrote: 
>  
>   
>> To: Cry <cry_regarder@yahoo.com>, linux-raid@vger.kernel.org 
>> From: David Lethe <david@santools.com> 
>> Subject: RE:  Re:  Re: Two Drive Failure on RAID-5 
>>  
>> Here is a good analogy that puts this in perspective.  I haven't seen 
>> anybody equate the two yet, so get the name right if you quote this ;) 
>>
>> Disk drives are like light bulbs. You can buy the server class (similar 
>> to CFLs), or desktop (incandescent).  If you don't mind the dark, 
>> replace them as they fail, and buy spares as they go on sale. 
>> Conversely, if you have to maintain a vaulted ceiling chandelier, and 
>> are afraid of heights, then spending twice as much for never having to 
>> deal with *THAT* again will seem like a bargain. 
>>
>> - David Lethe 
>>     
>  
> So are there such things as server class EIDE drives? Or are  
> they all SCSI or SATA? 
>  
> Keith 
>   
Different vendors have different strategies around how to market their 
various drives - you have archival (think big, slow S-ATA for things 
like a Tivo), S-ATA drives that are consumer grade or slightly higher 
class drive like SAS (serial attached SCSI) and then the highest quality 
drives (Fibre channel).

You can get good results from all classes of drives, but you need to 
make sure that you periodically check them pro-actively for errors and 
try to repair them in place if possible. Also, make sure you get an 
updated kernel so we don't kick out drives that would be otherwise 
perfectly reasonable ;-)

ric

