From: GuoZhong Han <hanguozhong@meganovo.com>
Subject: Re: make filesystem failed while the capacity of raid5 is big than 16TB
Date: Thu, 13 Sep 2012 11:21:33 +0800
Message-ID: <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com>
	<50504094.2040302@hesbynett.no>
	<CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com>
	<505059DD.8000108@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505059DD.8000108@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David:

         I am sorry for last mail that I had not described the
requirements of the system very clear.

         I will detail for you to describe the requirements of the system.

         This system has a 36 cores CPU, the frequency of each core is
1.2G. The system is designed to be a storage appliance product and a
management front end for it. The users can insert up to 16 disks to
the system and uses the interface that given by the appliance to
manage the disks and the arrays. The users can create a raid0, raid10
and raid5 use the disks they designated. After the array is be
created, the users can write to the array where the data they want.

         1. The system must support parallel write more than 150
files; the speed of each will reach to 1M/s. If the array is full,
wipe its data to re-write.

         2. Necessarily parallel the ability to read multiple files.

         3. as much as possible to use the storage space

         4. The system must have certain redundancy, when a disk
failed, the users can use other disk instead of the failed disk.

         5. The system must support disk hot-swap

         I have tested the performance for write of 4*2T raid5 and
8*2T raid5 of which the file system is ext4, the chuck size is 128K
and the strip_cache_size is 2048. At the beginning, these two raid5s
worked well. But there was a same problem, when the array was going to
be full, the speeds of the write performance tend to slower, there
were lots of data lost while parallel write 1M/s to 150 files.

         As you said, the performance for write of 16*2T raid5 will be
terrible, so what do you think that how many disks to be build to a
raid5 will be more appropriate?

         I do not know whether I describe the requirement of the
system accurately. I hope I can get your advice.

2012/9/12 David Brown <david.brown@hesbynett.no>
>
> Hi,
>
> (Please remember to include the linux raid mailing list in your replies, unless you have particular reason for posting off-list.
>
> And please post in plain-text only, not HTML.  HTML screws up quoting and formatting for emails.)
>
>
>
> On 12/09/2012 11:14, GuoZhong Han wrote:
>>
>> Hi David:
>>              Thanks for your reply.
>>              From your point of view, I feel like I made some mistakes.
>> And when I created the raid5,
>>              I noticed that the speed of the recovery is slower than
>> 4*2T raid5.while 4*2T can reach to 140MB/s,16*2T raid 70MB/s.
>
>
> I'll let others say exactly what is going on here, but I suspect it is simply that the single-threaded nature of raid5 gives poor performance here (as mentioned earlier, the md raid developers are working hard on this).
>
>
>>              The requirement of my application is :
>>              1.There are 16 2T disks in the system, the app must be able
>> to identify these disks.
>>              2.The users can create a raid0,raid10 or raid5 use the
>> disks they designated.
>>              3.Performance for writes of the array will reach at least
>> 100MB per second.
>
>
> This does not make sense as a set of requirements unless you are making a disk tester.  1 and 2 are a list of possible solutions, not a description of the application and requirements.
>
> Your requirements should be in terms of the required/desired storage space, the required/desired speeds, the required/desired redundancy, and the required/desired cost.
>
> The best solution to this depends highly on the mixture of reads and writes, the type of access (lots of small accesses or large streamed accesses), the level of parallelism (a few big client machines or processes, or lots in parallel), and the types of files (a few big files, lots of small files, databases, etc.).
>
>
>
>>              I had not tested the write performace for write of 16*2T raid5.
>>              There was a same problem about 4*2T raid5 and 8*2T raid5.
>> when the array was going to be full,
>>              the speed of the write performance tend to slower, and it
>> can not reach to 100MB/s.
>>              could you give me some advice?
>
>
> Yes - don't make raid5 from large numbers of disks arrays.  The performance is always bad (except for individual large streamed reads), and the redundancy is bad.  If you are trying to maximise the storage space for a given cost, then at least use raid6 unless your data is worthless (though performance will be even worse, especially for writes).  Otherwise there are better ways to structure your array.
>
> Once we know what you are trying to do, we can give better advice.
>
> mvh.,
>
> David
>
>
>
>> 2012/9/12 David Brown <david.brown@hesbynett.no
>> <mailto:david.brown@hesbynett.no>>
>>
>>
>>     On 12/09/2012 09:04, vincent wrote:
>>
>>         Hi, everyone:
>>                   I am Vincent, I am writing to you to ask a question
>>         about how to
>>         make file system about my raid5.
>>                   I created a raid5 with 16 *2T disks, it was OK.
>>                   Then I used mk2fs to make file system for the raid5.
>>                   Unfortunately, it was failed.
>>                   The output was:
>>                   # mke2fs -t ext4 /dev/md126
>>                     mke2fs 1.41.12 (17-May-2010)
>>                     mke2fs: Size of device /dev/md126 too big to be
>>         expressed in 32
>>         bits
>>                     using a blocksize of 4096.
>>                   Is anyone had the same problem? Could you help me?
>>                   The version of my mdadm is 3.2.2, and the version of
>>         my kernel is
>>         2.6.38
>>                   Thanks.
>>
>>
>>     You need e2fsprogs version 1.42 or above to create an ext4
>>     filesystem larger than 16 TB.
>>
>>     However, it is more common to use XFS for such large filesystems.
>>
>>     Another possibility is putting an LVM physical volume on the array
>>     and making multiple smaller logical partitions for your filesystem.
>>
>>     Almost certainly, however, a raid5 of 16 disks is a bad idea.
>>     Performance for writes will be terrible, as will parallel reads and
>>     writes (though that will improve dramatically as the current
>>     developments in multi-threaded raid5 make their way into mainstream
>>     distros).  And it is very poor from a reliability viewpoint - your
>>     risk of a second failure during a rebuild is high with a 16 disk raid5.
>>
>>     What is your actual application here?  If you tell us how this
>>     system will be used, it will be a lot easier to advise you on a
>>     better solution (perhaps a raid6, perhaps a raid10, perhaps a number
>>     of raid5 systems connected with raid0, perhaps multiple raid0 or
>>     raid5 arrays with a linear concatenation and XFS).
>>
>>
>
