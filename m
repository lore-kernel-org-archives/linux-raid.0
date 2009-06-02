From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Awful RAID5 random read performance
Date: Tue, 02 Jun 2009 14:54:07 -0400
Message-ID: <4A25754F.5030107@tmr.com>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com> <200905311056.30521.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200905311056.30521.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Fjellstrom wrote:
> On Sun May 31 2009, Leslie Rhorer wrote:
>   
>>>> I happen to be the friend Maurice was talking about. I let the raid
>>>>         
>>> layer keep
>>>
>>>       
>>>> its default chunk size of 64K. The smaller size (below like 2MB) tests
>>>>         
>>> in
>>>
>>>       
>>>> iozone are very very slow. I recently tried disabling readahead,
>>>>         
>>> Acoustic
>>>
>>>       
>>>> Management, and played with the io scheduler and all any of it has done
>>>>         
>>> is
>>>
>>>       
>>>> make the sequential access slower and has barely touched the smaller
>>>>         
>>> sized
>>>
>>>       
>>>> random access test results. Even with the 64K iozone test random
>>>>         
>>> read/write is
>>>
>>>       
>>>> only in the 7 and 11MB/s range.
>>>>
>>>> It just seems too low to me.
>>>>         
>>> I don't think so; can you try a similar test on single drives not using
>>> md RAID-5?
>>>
>>> The killer is seeks, which is what random I/O uses lots of; with a 10ms
>>> seek time you're only going to get ~100 seeks/second and if you're only
>>> reading 512 bytes after each seek you're only going to get ~500
>>> kbytes/second. Bigger block sizes will show higher throughput, but
>>> you'll still only get ~100 seeks/second.
>>>
>>> Clearly when you're doing this over 4 drives you can have ~400
>>> seeks/second but that's still limiting you to ~400 reads/second for
>>> smallish block sizes.
>>>       
>> 	John is perfectly correct, although of course a 10ms seek is a
>> fairly slow one.  The point is, it is drive dependent, and there may not be
>> much one can do about it at the software layer.  That said, you might try a
>> different scheduler, as the seek order can make a difference.  Drives with
>> larger caches may help some, although the increase in performance with
>> larger cache sizes diminishes rapidly beyond a certain point.  As one would
>> infer from John's post, increasing the number of drives in the array will
>> help a lot, since increasing the number of drives raises the limit on the
>> number of seeks / second.
>>
>> 	What file system are you using?  It can make a difference, and
>> surely has a bigger impact than most tweaks to the RAID subsystem.
>>
>> 	The biggest question in my mind, however, is why is random access a
>> big issue for you?  Are you running a very large relational database with
>> tens of thousands of tiny files?  For most systems, high volume accesses
>> consist mostly of large sequential I/O.  The majority of random I/O is of
>> rather short duration, meaning even with comparatively poor performance, it
>> doesn't take long to get the job done.  Fifty to eighty Megabits per second
>> is nothing at which to sneeze for random access of small files.  A few
>> years ago, many drives would have been barely able to manage that on a
>> sustained basis for sequential I/O.
>>     
>
> I thought the numbers were way too low. But I guess I was wrong. I really only 
> have three use cases for my arrays. One will be hosting VM images/volumes, and 
> iso disk images, while another will be hosting large media which will be 
> streaming off, p2p downloads, amd rsync/rsnapshot backups of several machines. 
> I imagine the vm array will appreciate faster random io (boot times will 
> improve, as will things like database and http disk access), and the p2p 
> surely will appreciate faster random io.
>
> I currently have them all on one disk array, but I'm thinking its a good idea 
> to separate the media from the VMs. when ktorrent is downloading a linux iso 
> or something similar atop shows very high disk utilization for ktorrent, same 
> goes for booting VMs. and the backups, oh my lord does that take a while, I 
> even tell it to skip a lot of stuff I don't need to backup.
>
> When I get around to it I may utilize the raid10 module for the VM's and 
> backups. Though that may decrease performance a little bit in the small random 
> io case. 
>   
The accesses on the VM will be similar to a real disk, so you want the 
VM on whatever you would use for bare iron. I run on raid10, many of my 
machines are on VM (including this one, my main desktop). Raid10 is a 
good general use array, I use it for a lot, other than cases where I 
need cheap space and use raid[56] to get more bytes/$ and don't need 
blinding speed. Archival storage, for instance.

-- 
Bill Davidsen <davidsen@tmr.com>
  Even purely technical things can appear to be magic, if the documentation is
obscure enough. For example, PulseAudio is configured by dancing naked around a
fire at midnight, shaking a rattle with one hand and a LISP manual with the
other, while reciting the GNU manifesto in hexadecimal. The documentation fails
to note that you must circle the fire counter-clockwise in the southern
hemisphere.


