From: Sebastian Sobolewski <linux@thirdmartini.com>
Subject: Re: Write and verify correct data to read-failed sectors before degrading
 array?
Date: Thu, 16 Sep 2004 20:13:05 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414A4831.1040407@thirdmartini.com>
References: <41420D07.4060001@steeleye.com>	<16709.12517.514905.627708@cse.unsw.edu.au>	<41487D18.1050000@steeleye.com>	<4149700F.6060509@buttersideup.com>	<16714.12891.987589.769643@cse.unsw.edu.au>	<414A40DB.6070309@thirdmartini.com> <16714.17729.576621.347771@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16714.17729.576621.347771@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Neil Brown wrote:

>On Thursday September 16, linux@thirdmartini.com wrote:
>  
>
>>    I have some experimental code that does the read-recovery piece for 
>>raid1 devices against kernel 2.4.26.  If an error is encountered on a 
>>read, the failure is delayed until the read is retried to the other 
>>mirror.  If the retried read succeeds it then writes the recovered block 
>>back over the previously failed block. 
>>    If the write fails then the drive is marked faulty otherwise we 
>>continue without setting the drive faulty.  ( The idea here is that 
>>modern disk drives have spare sectors, and will be automatically 
>>reallocate a bad sector to one of the spares on the next write ). 
>>    The caveat is that if the drive is generating lots of bad/failed 
>>reads it's most likely going south.. but that's what smart log 
>>monitoring is for.  If anyone is interested I can post the patch.
>>    
>>
>
>Certainly interested.
>
>Do you have any interlocking to ensure that if a real WRITE is
>submitted immediately after (or even during !!!) the READ, it does not
>get destroyed by the over-write.
>e.g.
>
>application     drive0          drive1
>READ request
>                READ from drive 0
>		fails
>				READ from drive 1
>				success. Schedule over-write on drive0
>READ completes
>WRITE block
>		WRITE to drive0 WRITE to drive1
>
>                overwrite happens.
>
>
>It is conceivable that the WRITE could be sent even *before* the READ
>completes though I'm not sure if it is possible in practice.
>
>NeilBrown
>
>  
>
    No, there is no interlocking at this time. I solve the above problem 
by  not replying to the read until after the recovery write attempt 
either fails or completes.  This works great when the application above 
us ( like a FS ) is using the buffer cache or guarantees no R-W 
conflicts.  ( I believe this is the case with buffered block devices at 
this time ).  Using /dev/raw and an application that can cause R-W 
conflicts WILL result in corruption.  This is why the patch is 
experimental. :)

    I've tested the code on a fault injector and I have not been able to 
cause a corruption using ext3 or xfs. 

-Sebastian

