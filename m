From: Cry <cry_regarder@yahoo.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Sat, 31 May 2008 09:27:56 +0000 (UTC)
Message-ID: <loom.20080531T085813-896@post.gmane.org>
References: <loom.20080519T224713-779@post.gmane.org> <4832966A.3010707@dgreaves.com> <loom.20080521T140522-597@post.gmane.org> <483482E2.60300@dgreaves.com> <09ed01c8bb83$ec3f7230$9300a8c0@dcccs> <loom.20080521T210407-628@post.gmane.org> <48353110.8060602@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david <at> dgreaves.com> writes:

> Cry wrote:
>> Janos Haar <janos.haar <at> netcenter.hu> writes:
>> 
>> Folks, I made a mistake when I created my original raid array 
>> (there is a note about it in the archives of this group) that 
>> I built the array on the raw drives, not on partitions.
> 
> When people offer suggestions they (or at least I) will probably form
> a picture of what's going on - if you are going to throw tweaks into 
> the mix then they may throw us off. Mention them.

Point taken.

> You have failed to answer some potentially relevant questions and, 
> before you get this array rebuilt you wandered off (on the same 
> thread) into discussions about what disk drives you might like to 
> buy, the best type of external enclosure and various other oddments. 
> This is not helpful.

Yup, I should have put that stuff into a separate thread.  That said, I
did get good feedback on those questions on the other branch of the thread.

> You're on 0.9 superblocks which are located at the end of the disk.

Thanks for the above line.  It was key.
 
> You have now dug a maze of twisty passages...

:-)
 
> I think at this point you should enlarge /dev/sdg1, recopy /dev/sda to
> /dev/sdg1 and try again. That will probably work.

What I ended up doing was writing off the extra 250G in /dev/sdg and using
ddrescue to copy the failed drive to it.

ddrescue -dr3 /dev/sdf /dev/sdg 750_ddrescue.log
Press Ctrl-C to interrupt
Initial status (read from logfile)
rescued:   500107 MB,  errsize:    356 kB,  errors:      72
Current status
rescued:   500107 MB,  errsize:   48128 B,  current rate:        0 B/s
   ipos:   482042 MB,   errors:      79,    average rate:      269 B/s
   opos:   482042 MB
Copying bad blocks... Retry 1

It was nice that ddrescue as invoked got a good chunk more off the drive
than I'd gotten with dd_rescue.

The interesting thing was that mdadm -E /dev/sdg reported that there wasn't
a superblock on it!  Then I remembered your note above about where the
superblocks are located so I figured that the data was all fine, just that the
superblock was in the wrong place.  So I let mdadm assemble the array:

At this point, I have moved the drives around extensively so drive letters
do not match earlier posts:

mdadm --create /dev/md0 --verbose --level=5 --raid-devices=6 --chunk=128
/dev/sdl /dev/sdi /dev/sdj missing /dev/sdg /dev/sdk

mdadm: layout defaults to left-symmetric
mdadm: /dev/sdl appears to be part of a raid array:
    level=raid5 devices=6 ctime=Thu May 24 01:55:48 2007
mdadm: /dev/sdi appears to be part of a raid array:
    level=raid5 devices=6 ctime=Thu May 24 01:55:48 2007
mdadm: /dev/sdj appears to be part of a raid array:
    level=raid5 devices=6 ctime=Thu May 24 01:55:48 2007
mdadm: /dev/sdk appears to be part of a raid array:
    level=raid5 devices=6 ctime=Thu May 24 01:55:48 2007
mdadm: size set to 488386432K
mdadm: largest drive (/dev/sdg) exceed size (488386432K) by more than 1%
Continue creating array? yes
mdadm: array /dev/md0 started.

At this point I was able to recover all but a couple files onto a second
raid array.  

Thanks David Greaves and Janos Haar for the wonderful advice on restoring
my data.  Thanks to David Lethe for the advice to get the server class 
drives and thanks to Brad Campbell for endorsing the supermicro CSE-M35T
enclosure.  It was quite easy to install and seems to be working well and
keeping the drives nice and cool.

The old and the new arrays:

md0 : active raid5 sdk[5] sdg[4] sdj[2] sdi[1] sdl[0]
      2441932160 blocks level 5, 128k chunk, algorithm 2 [6/5] [UUU_UU]
      
md1 : active raid6 sdd1[3] sdc1[2] sde1[4] sda1[0] sdb1[1]
      2930279808 blocks level 6, 128k chunk, algorithm 2 [5/5] [UUUUU]
      
Thanks again,

Cry





