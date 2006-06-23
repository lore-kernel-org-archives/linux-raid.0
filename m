From: Russell Cattelan <cattelan@thebarn.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 11:21:34 -0500
Message-ID: <449C150E.3040107@thebarn.com>
References: <449AEB7C.6040108@cjx.com> <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com> <200606231701.44803.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1256; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200606231701.44803.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Al Boldi wrote:

>Chris Allen wrote:
>  
>
>>Francois Barre wrote:
>>    
>>
>>>2006/6/23, PFC <lists@peufeu.com>:
>>>      
>>>
>>>>        - XFS is faster and fragments less, but make sure you have a
>>>>good UPS
>>>>        
>>>>
>>>Why a good UPS ? XFS has a good strong journal, I never had an issue
>>>with it yet... And believe me, I did have some dirty things happening
>>>here...
>>>
>>>      
>>>
>>>>        - ReiserFS 3.6 is mature and fast, too, you might consider it
>>>>        - ext3 is slow if you have many files in one directory, but
>>>>has more
>>>>mature tools (resize, recovery etc)
>>>>        
>>>>
>>>XFS tools are kind of mature also. Online grow, dump, ...
>>>
>>>      
>>>
>>>>        I'd go with XFS or Reiser.
>>>>        
>>>>
>>>I'd go with XFS. But I may be kind of fanatic...
>>>      
>>>
>>Strange that whatever the filesystem you get equal numbers of people
>>saying that they have never lost a single byte to those who have had 
>>horrible corruption and would never touch it again. We stopped using XFS 
>>about a year ago because we were getting kernel stack space panics under 
>>heavy load over NFS. It looks like the time has come to give it another
>>try.
>>    
>>
>
>If you are keen on data integrity then don't touch any fs w/o data=ordered.
>
>ext3 is still king wrt data=ordered, albeit slow.
>
>Now XFS is fast, but doesn't support data=ordered.  It seems that their 
>solution to the problem is to pass the burden onto hw by using barriers.  
>Maybe XFS can get away with this.  Maybe.
>
>Thanks!
>
>--
>  
>
When you refer to data=ordered are you taking about ext3 user data 
journaling?

While user data journaling seems like a good idea is unclear as what 
benefits it really provides?
By writing all user data twice the write performance of the files system 
is effectively halved.
Granted the log is on area of the disk so some performance advantages 
show up due
to less head seeking for those writes.

As far us meta data jornaling goes it is a fundamental requirement that 
the journal is
synced to disk to a given point in order to release the pinned meta 
data, thus allowing
the meta data to be synced to disk.

The way most files systems guarantee file system consistency is to 
either sync all
outstanding meta data changes to disk or to sync a record of what incore 
changes
have been made to disk.

In the XFS case since it logs meta data delta to the log it can record more
change operations in a smaller number of disk blocks, ext3 on the other hand
writes the entire metadata block to the log.

As far as barriers go I assume you are referring to the ide write barriers?

The need for barrier support in the file system is a result of cheap ide
disks providing large write caches but not having enough reserve power to
guarantee that the cache will be sync'ed to disk in the event of a power
failure.

Originally when xfs was written the disks/raids used by SGI system was 
pretty
much exclusively enterprise level devices that would guarantee the write 
caches
would be flushed in the event of a power failure.

Note ext3,xfs,and reiser all use write barrier now fos r ide disks.




