From: Carlos Knowlton <cknowlton@update.fsix.com>
Subject: Re: Is there a drive error "retry" parameter?
Date: Tue, 14 Jun 2005 16:53:17 -0500
Message-ID: <42AF51CD.7050102@update.fsix.com>
References: <200505021224.35396.mlaks@verizon.net> <429F2458.6070404@update.fsix.com> <429F3ED5.4020005@tls.msk.ru>
Reply-To: cknowlton@science.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429F3ED5.4020005@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Michael,

Michael Tokarev wrote:

>Carlos Knowlton wrote:
>  
>
>>I want to understand exactly what is going on in the Software RAID 5
>>code when a drive is marked "dirty", and booted from the array.  Based
>>on what I've read so far, it seems that this happens any time the RAID
>>software runs into a read or write error that might have been corrected
>>by fsck (if it had been there first).  Is this true?
>>    
>>
>
>You're mixing up 2 very different things here.  Very different.
>
>Fsck has nothing to do with raid, per se.  Fsck checks the filesystem
>which is on top of a block device (be it a raid array, a disk, or a
>loopback device, whatever).  It does not understand/know what is "raid",
>at all.  Speaking of raid, the filesystem is an upper-level stuff.  Again,
>raid code knows nothing about filesystems or any data it stores.  Also,
>filesystem obviously does not know about underlying components of the
>raid array where the filesystem resides -- so fsck can NOT "fix" whatever
>error happened two layers down the stack (fs, raid, underlying devices).
>
From the other side, raid code ensures (or tries to, anyway) that any
>errors in underlying (components) devices will not propagate to the
>upper level (be it a filesystem, database or anything else - raid does
>not care what data it stores).  It is here to "hide" whatever errors
>may happen on the physical device (disk drive).  Currently, if enouth
>drives fails, raid array will be "shut down" so that the upper level
>(eg filesystem) can't even access the whole raid array.  Until that
>happens, there should be no errors propagated to the filesystem layer,
>all such errors will be corrected by raid code, ensuring that it will
>read the same data as has been written to it.
>  
>
Thanks, that is good to know!   I had read a discussion from this list a 
few months ago that I must have gotten the wrong impression from. 
<http://marc.theaimsgroup.com/?l=linux-raid&m=108852478803297&w=2>.

Maybe you can help me clarify some other misconceptions I have.  For 
instance, I had heard that with most modern hard disks, when they run 
into a bad sector, they will map around that sector, and copy the data 
to another place on the disk.  Do you know if this is true?  If so, how 
does this impact RAID? (ie, Is RAID benefited by this, or does it 
override it?)


>>Is there a "retry" parameter that can be set in the kernel parameters,
>>or else in the code itself to prolong the existence of a drive in an
>>array before it is considered dirty?
>>    
>>
>
>There's no such parameter currently.  But there was several discussions
>about how to make raid code more robust - in particular, in case of
>read error, raid code may keep the errored drive in the array and mark
>it dirty only in case of write error.
>  
>
That would be nice.  Do you know if anyone has done any work toward such 
a fix?

>>If so, I would like to increase it in my environment, because it seems
>>like I'm losing drives in my array that are often still quite stable.
>>    
>>
>
>I think you have to provide some more information.  Kernel logging tells
>alot of details about what exactly happening and what the raid code is
>doing as a result of that.
>  
>
Unfortunately, I don't have the logs handy, but I'll post something next 
time I see it.   I built several RAID servers for some customers over a 
year ago, and they have reported drive failures.  We have replaced these 
and when we tested the old drives they were still in fairly good 
condition.  So for the last little while, I have just reinserted the 
drive back into the array, and it usually doesn't cause any trouble 
again (though occasionally a different drive will fail).  If there is a 
way to keep the drive in the array a little longer,  when a read error 
is detected, it would really help!


Thanks!
Carlos Knowlton
