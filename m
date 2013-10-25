From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Linux MD? Or an H710p?
Date: Fri, 25 Oct 2013 04:34:36 -0500
Message-ID: <526A3B2C.8050800@hardwarefreak.com>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home> <5265C89A.4000908@gmail.com> <52662849.1080003@hesbynett.no> <5266AE51.4050501@hardwarefreak.com> <526774B4.400@hesbynett.no> <5268BCD6.4000305@hardwarefreak.com> <5268CB88.9060002@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5268CB88.9060002@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Steve Bergman <sbergman27@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/24/2013 2:26 AM, David Brown wrote:
> On 24/10/13 08:23, Stan Hoeppner wrote:
>> On 10/23/2013 2:03 AM, David Brown wrote:
>>
>>> On the other hand, he is also serving 100+ freenx desktop users.  As far
>>> as I understand it (and I'm very happy for corrections if I'm wrong),
>>> that will mean a /home directory with 100+ sub-directories for the
>>> different users - and that /is/ one of the ideal cases for concat+XFS
>>> parallelism.
>>
>> No, it is /not/.  Homedir storage is not an ideal use case.  It's not
>> even in the ballpark.  There's simply not enough parallelism nor IOPS
>> involved, and file sizes can vary substantially, so the workload is not
>> deterministic, i.e. it is "general".  Recall I said in my last reply
>> that this "is a very workload specific storage architecture"?
>>
>> Workloads that benefit from XFS over concatenated disks are those that:
>>
>> 1.  Expose inherent limitations and/or inefficiencies of striping,
>>     at the filesystem, elevator, and/or hardware level
>>
>> 2.  Exhibit a high degree of directory level parallelism
>>
>> 3.  Exhibit high IOPS or data rates
>>
>> 4.  Most importantly, exhibit relatively deterministic IO patterns
>>
>> Typical homedir storage meets none of these criteria.  Homedir files on
>> a GUI desktop terminal server are not 'typical', but the TS workload
>> doesn't meet these criteria either.

If you could sum up everything below into a couple of short, direct,
coherent questions you have, I'd be glad to address them.




> I am trying to learn from your experience and knowledge here, so thank
> you for your time so far.  Hopefully it is also of use and interest to
> others - that's one of the beauties of public mailing lists.
> 
> 
> Am I correct in thinking that a common "ideal use case" is a mail server
> with lots of accounts, especially with maildir structures, so that
> accesses are spread across lots of directories with typically many
> parallel accesses to many small files?
> 
> 
> First, to make sure I am not making any technical errors here, I believe
> that when you make your XFS over a linear concat, the allocation groups
> are spread evenly across the parts of the concat so that logically (by
> number) adjacent AG's will be on different underlying disks.  When you
> make a new directory on the filesystem, it gets put in a different AG
> (wrapping around, of course, and overflowing when necessary).  Thus if
> you make three directories, and put a file in each directory, then each
> file will be on a different disk.  (I believe older XFS only allocated
> different top-level directories to different AG's, but current XFS does
> so for all directories).
> 
> 
> 
> I have been thinking about what the XFS over concat gives you compared
> to XFS over raid0 on the same disks (or raid1 pairs - the details don't
> matter much).
> 
> First, consider small files.  Access to small files (smaller than the
> granularity of the raid0 chunks) will usually only involve one disk of
> the raid0 stripe, and will /definitely/ only involve one disk of the
> concat.  You should be able to access multiple small files in parallel,
> if you are lucky in the mix (with raid0, this "luck" will be mostly
> random, while with concat it will depend on the mix of files within
> directories.  In particular, multiple files within the same directory
> will not be paralleled).  With a concat, all relevant accesses such as
> directory reads and inode table access will be within the same disk as
> the file, while with raid0 it could easily be a different disk - but
> such accesses are often cached in ram.  With raid0 you have the chance
> of the small file spanning two disks, leading to longer latency for that
> file and for other parallel accesses.
> 
> All in all, small file access should not be /too/ different - but my
> guess is concat has the edge for lowest overall latency with multiple
> parallel accesses, as I think concat will avoid jumps between disks better.
> 
> 
> For large files, there is a bigger difference.  Raid0 gives striping for
> higher throughput - but these accesses block the parallel accesses to
> other files.  concat has slower throughput as there is no striping, but
> the other disks are free for parallel accesses (big or small).
> 
> 
> To my mind, this boils down to a question of balancing - concat gives
> lower average latencies with highly parallel accesses, but sacrifices
> maximum throughput of large files.  If you don't have lots of parallel
> accesses, then concat gains little or nothing compared to raid0.
> 
> 
> If I try to match up this with the points you made, point 1 about
> striping is clear - this is a major difference between concat and raid0.
>  Point 2 and 3 about parallelism and high IOPs (and therefore low
> latency) is also clear - if you don't need such access, concat will give
> you nothing.
> 
> Only the OP can decide if his usage will meet these points.
> 
> But I am struggling with point 4 - "most importantly, exhibit relatively
> deterministic IO patterns".  All you need is to have your file accesses
> spread amongst a range of directories.  If the number of (roughly)
> parallel accesses is big enough, you'll get a fairly even spread across
> the disks - and if it is not big enough for that, you haven't matched
> point 2.  This is not really much different from raid0 - small accesses
> will be scattered across the different disks.  The big difference comes
> when there is a large file access - with raid0, you will block /all/
> other accesses for a time, while with concat (over three disks) you will
> block one third of the accesses for three times as long.

