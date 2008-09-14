From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Expandable raid
Date: Sun, 14 Sep 2008 12:29:24 -0400
Message-ID: <48CD3BE4.6070709@tmr.com>
References: <48CBDC40.1010505@tmr.com> <18636.62107.274386.224236@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18636.62107.274386.224236@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:
>> I am setting up a system with five drives. Initially two will
>> be for the system and three for other uses. In about 4-6 weeks
>> the three will be added to the original two.
>>     
>
> What does "added" mean here? Physically? Logically? If logically,
> in what way? And what's the starting point?  If you start with 5
> drives, why configure them initially as 2 arrays, and then merge
> later into 1 array? The exact array shapes involved matter.
>
>   
Means I have five drives and need three for a project so they can't be 
part of the original system configuration. I will put system on two, and 
add the others after the project requiring them is complete.
>> Thoughts on picking a raid config to make this easy? I would
>> like to use raid-10, but I don't see a way to grow it.
>>     
>
> What's "this"? Do you want to end up with a 5-drive array? If
> so, where are you going to put the boot filesystem (most BIOSes
> require single drive boot filesystems) unless it is a 5 drive
> RAID1? In which case, growing is easy :-).
>   

I always put the boot filesystem on raid1, over the first two drives (as 
seen by the BIOS). That way if one fails the BIOS boots the other. Once 
the system is up I can have the rest of the data as I want it. Generally 
a 200-200MB boot partition is adequate, with MBR written to both drives.
> More generally, my usual story: growing an array is a dangerous
> and slow operation. Backup and restore is usually a lot faster,
> results in a better physical to logical layout, and safer (and
> one should backup anyhow before growing).
>   

If I had the resources for backup space I would have just put more 
drives in the box, used a bigger box, etc. I'm looking for proposed 
solutions to the problem I have, rather than ways to avoid having the 
problem if I had resources I don't have.
> BTW I was just looking at his home page for other reasons (NFSv4)
> and noticed this:
>
>   http://neil.brown.name/hg
>
>     "LaFS Log Structured File system for Linux - VERY alpha
>      Neil Brown 7 weeks ago RSS".
>   

Not really very descriptive, the filesystem which interests me at the 
moment is the one Compaq released from their UNIX on Alpha o/s, Tru64 
IIRC. It has the advantage of having been in enterprise use for about a 
decade, and gets good marks from people I actually know and trust. 
Compared to Reiser4, ZFS, and even XFS (from what I hear) it seems to 
offer good real world performance without guru-level tuning and initial 
setup.

Always interesting, of course.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


