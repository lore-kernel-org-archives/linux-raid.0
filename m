From: Mark Bellon <mbellon@mvista.com>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 12:35:29 -0700
Message-ID: <41F00801.2050807@mvista.com>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu> <Pine.LNX.4.56.0501201805070.12589@lion.drogon.net> <41EFFA53.3030809@mvista.com> <Pine.LNX.4.58.0501201205490.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0501201205490.19586@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: David Dougall <davidd@et.byu.edu>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Dougall wrote:

>Oooh, that ~3 second patch sounds very interesting.  I actually think that
>the theory about timeouts causing the problem is correct.  I didn't
>realize that applications/fs calls could stall for that long.  My NFS
>servers have a timeout themselves of about 10 seconds before they start to
>try to shut things down.
>  
>
I could generate one for 2.4.26 for you but I need a bit of time - I'm 
running a 2.4.20 with a great many enhancements and there are a few 
differences. If there is interested I can post it to linux-raid too.

mark

>--David Dougall
>
>
>On Thu, 20 Jan 2005, Mark Bellon wrote:
>
>  
>
>>Gordon Henderson wrote:
>>
>>    
>>
>>>On Thu, 20 Jan 2005, David Dougall wrote:
>>>
>>>
>>>
>>>      
>>>
>>>>Perhaps I was asking a stupid question or an obvious one, but I have
>>>>received not response.
>>>>Maybe if I simplify the question...
>>>>
>>>>If I am running software raid1 and a disk device starts throwing I/O
>>>>errors, Is the filesystem supposed to see any indication of this?
>>>>
>>>>
>>>>        
>>>>
>>>No..
>>>
>>>
>>>
>>>      
>>>
>>>>I
>>>>thought software raid would mask all of this and just fail the drive.
>>>>
>>>>
>>>>        
>>>>
>>>It should.
>>>
>>>
>>>
>>>      
>>>
>>>>I have servers with xfs as the filesystem and xfs will start to throw I/O
>>>>errors when a disk starts acting up even with software raid in between.
>>>>Please advise on how I can confirm my setup or if this is possibly a bug
>>>>how to diagnose further.
>>>>
>>>>
>>>>        
>>>>
>>>I've experienced long delays (30 seconds? It seemed longer) in a system
>>>when a disk fails for a genuine reason - (I've deliberately run badblocks
>>>on an md device when I knew one of the underlying devices had genuine bad
>>>blocks) maybe the md code really tries hard to read the block, maybe the
>>>underlying device driver tries really hard), but in these cases, I've seen
>>>the system more or less freeze (all processes accessing that device
>>>anyway) until the raid code decided to kick the device out of the array.
>>>
>>>
>>>      
>>>
>>I've seen this too. The worst case can actually last for over 2 minutes.
>>
>>We've been running with a patch to the RAID 1 driver that handles this
>>so critical applications do not hang for too long. Basically it uses
>>timers in the RAID 1 driver to force the disk to be treated as actually
>>having failed if it doesn't respond within a reasonable time (tunable
>>but usually ~3 seconds). It then handles the I/O requests coming back
>>async. and does the clean up.
>>
>>    
>>
>>>Maybe XFS has a timer and doesn't like devices to "go away" for a long period of time?
>>>
>>>
>>>      
>>>
>>Not that I know of but I would need to look. Any XFS wizard's comments?
>>
>>mark
>>
>>    
>>
>>>      
>>>
>>>>If it makes a difference, I am running linux-2.4.26
>>>>
>>>>
>>>>        
>>>>
>>>I've used 2.4.x for a long time - I did try xfs about a year ago, but
>>>wasn't happy with it all (for various reasons).
>>>
>>>Gordon
>>>-
>>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>      
>>>
>>
>>    
>>

