From: David Brown <david@westcontrol.com>
Subject: Re: possibly silly question (raid failover)
Date: Wed, 02 Nov 2011 11:36:43 +0100
Message-ID: <j8r6qg$quq$1@dough.gmane.org>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org> <4EB052E6.4050400@meetinghouse.net> <20111101212023.GA20565@cthulhu.home.robinhill.me.uk> <4EB06561.8090706@meetinghouse.net> <j8pq51$jol$1@dough.gmane.org> <4EB07993.7000906@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB07993.7000906@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/11/2011 23:58, Miles Fidelman wrote:
> David Brown wrote:
>>
>> You are aware, of course, that if you take your 16 drives and use
>> "-n8", you will get a total disk space equivalent to two drives. It
>> would be very resistant to drive failures, but /very/ poor space
>> efficiency. It would also be very fast for reads, but very slow for
>> writes (as everything must be written 8 times).
>>
>> It's your choice - md is very flexible. But I think an eight-way
>> mirror would be considered somewhat unusual.
>
> What would be particularly interesting is if I can do -n4 and configure
> things in a way that insures that each of those 4 is on a different one
> of my 4 boxes (4 boxes, 4 disks each).
>

Theoretically, that's just a matter of getting the ordering right when 
you are creating the array.

However, it is a lot easier to get this right if you separate the stages 
into setting up 4 raid1 sets, then combine them.

Remember, md RAID10 is good - but it is not always the best choice.  It 
is particularly good for desktop use on two disks, or perhaps 3 disks, 
with the "far2" layout - giving you excellent speed and safety.  Its 
advantages over standard RAID1+0 drop as the number of disks increase. 
In particular, RAID10 in "near" format is identical to RAID1+0 if you 
have a multiple of 4 disks - "far" format still has some speed 
advantages since it can always read from the faster outer half of the disk.

Also note that the benefits of striping also drop off for bigger disk 
sets (unless you have very big files, they don't fill the stripes), and 
if you have multiple concurrent accesses - typical for severs - striping 
doesn't help much.

Finally, remember the main disadvantage of md RAID10 - once it is 
established, you have very few re-shape possibilities.  RAID0 and RAID1 
sets can be easily re-shaped - you can change their size, and you can 
add or remove drives.  This means that if you build your system using 
RAID1 mirrors and RAID0 striping on top, you can add new servers or 
change the number of disks later.

You need to establish what your needs are here - what sort of files will 
be accessed (big, small, etc.), what will access patterns be like (large 
streamed accesses, lots of concurrent small accesses, many reads many 
writes, etc.), and what your storage needs are (what disk sizes are you 
using, and what total usable disk space are you aiming for?).

One idea would be to set up 8 2-way mirrors, with the mirrors split 
between different machines.  These 8 pairs could then be combined with 
RAID6.  That gives you 6 disks worth of total space from your 16 disks, 
and protects you against at least 5 concurrent disk failures, or two 
complete server fails, if you arrange the pairs like this:

Server 1:  1a 3a 5a 7a
Server 2:  1b 4a 6a 7b
Server 3:  2a 3b 6b 8a
Server 4:  2b 4b 5b 8b

(Where 1a, 1b are the two halves of the same mirror.)









