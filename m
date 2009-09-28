From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Full use of varying drive sizes?---maybe a new raid mode is the
 answer?
Date: Mon, 28 Sep 2009 17:10:51 +0300
Message-ID: <4AC0C3EB.30606@gmail.com>
References: <228790.21625.qm@web51307.mail.re2.yahoo.com>	<4ABA8506.3080800@gmail.com> <87ske7s5lb.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ske7s5lb.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Jon@eHardcastle.com, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Konstantinos Skarlatos <k.skarlatos@gmail.com> writes:
>
>   
>> Instead of doing all those things, I have a suggestion to make:
>>
>> Something that is like RAID 4 without striping.
>>
>> There are already 3 programs doing that, Unraid, Flexraid and
>> disparity, but putting this functionality into linux-raid would be
>> tremendous. (the first two work on linux and the third one is a
>> command line windows program that works fine under wine).
>>
>> The basic idea is this: Take any number of drives, with any capacity
>> and filesystem you like. Then provide the program with an empty disk
>> at least as large as your largest disk. The program creates parity
>> data by XORing together the disks sequentially block by block(or file
>> by file), until it reaches the end of the smallest one.(It XORs block
>> 1 of disk A with block1 of disk B, with block1 of disk C.... and
>> writes the result to block1 of Parity disk) Then it continues with the
>> rest of the drives, until it reaches the end of the last drive.
>>
>> Disk     A    B   C   D   E    P
>> Block   1    1    1    1    1    1
>> Block   2    2    2                2
>> Block   3    3                      3
>> Block   4                            4
>>
>> The great thing about this method is that when you lose one disk you
>> can get all your data back. when you lose two disks you only lose the
>> data on them, and not the whole array. New disks can be added and the
>> parity recalculated by reading only the new disk and the parity disk.
>>     
>
> This has some problem though:
>
> 1) every wite is a read-modify-write
>    Well, for one thing this is slow.
>   
Is that necessary? Why not read every other data disk at the same time 
and calculate new parity blocks on the fly? granted, that would mean 
spinning up every disk, so maybe this mode could be an option?
> 2) every write is a read-modify-write of the parity disk
>    Even worse, all writes to independent disks bottleneck at the
>    parity disk.
> 3) every write is a read-modify-write of the parity disk 
>    That poor parity disk. It can never catch a break, untill it
>    breaks. It is likely that it will break first.
>   
No problem, a failed parity disk on this method is a much smaller 
problem than a failed disk on a RAID 5
> 4) if the parity disk is larger than the 2nd largest disk it will
>    waste space
> 5) data at the start of the disk is more likely to fail than at the
>    end of a disk
>    (Say disks A and D fail then Block A1 is lost but A2-A4 are still
>    there)
>
> As for adding a new disks there are 2 cases:
>
> 1) adding a small disk
>    zero out the new disk and then the parity does not need to be updated
> 2) adding a large disk
>    zero out the new disk and then that becomes the parity disk
>   
So the new disk gets a copy of the parity data of the previous parity disk?
>   
>> Please consider adding this feature request, it would be a big plus
>> for linux if such a functionality existed, bringing many users from
>> WHS and ZFS here, as it especially caters to the needs of people that
>> store video and their movie collection at their home server.
>>
>> Thanks for your time
>>
>>
>> ABCDE for data drives, and P for parity
>>     
>
> As a side note I like the idea of not striping, despide the uneven
> use. For home use the speed of a single disk is usualy sufficient but
> the noise of concurrent access to multiple disks is bothersome. 
Have you tried the Seagate Barracuda LP's? totally silent! I have 8 of 
them and i can assure you that they are perfect for large media storage 
in a silent computer.
> Also
> for movie archives a lot of access will be reading and then the parity
> disk can rest. Disks can also be spun down more often. Only the disk
> containing the movie one currently watches need to be spinning. That
> could translate into real money saved on the electric bill.
>
>   
I agree this is something mainly for home use, where reads exceed writes 
by a large margin and when writes are done, they are done to one or two 
disks at the same time at most.
> But I would still do this with my algorithm to get even amount of
> redunancy. One can then use partitions or lvm to split the overall
> raid device back into seperate drives if one wants to.
>   
Yes I think that an option for merging the disks into a large one would 
be nice, as long as data is still recoverable from individual disks if 
for example 2 disks fail. One of the main advantages of not stripping is 
that when things go haywire some data is still recoverable, so please 
lets not lose that.
> MfG
>         Goswin
>   

