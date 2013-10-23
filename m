From: David Brown <david.brown@hesbynett.no>
Subject: Re: Linux MD? Or an H710p?
Date: Wed, 23 Oct 2013 09:03:16 +0200
Message-ID: <526774B4.400@hesbynett.no>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home> <5265C89A.4000908@gmail.com> <52662849.1080003@hesbynett.no> <5266AE51.4050501@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5266AE51.4050501@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Steve Bergman <sbergman27@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/10/13 18:56, Stan Hoeppner wrote:
> On 10/22/2013 2:24 AM, David Brown wrote:
>> On 22/10/13 02:36, Steve Bergman wrote:
>>
>> <snip>
>>
>>> But hey, this is going to be a very nice opportunity for observing XFS's
>>> savvy with parallel i/o.
>>
>> You mentioned using a 6-drive RAID10 in your first email, with XFS on
>> top of that.  Stan is the expert here, but my understanding is that you
>> should go for three 2-drive RAID1 pairs, and then use an md linear
>> "raid" for these pairs and put XFS on top of that in order to get the
>> full benefits of XFS parallelism.
> 
> XFS on a concatenation, which is what you described above, is a very
> workload specific storage architecture.  It is not a general use
> architecture, and almost never good for database workloads.  Here most
> of the data is stored in a single file or a small set of files, in a
> single directory.  With such a DB workload and 3 concatenated mirrors,
> only 1/3rd of the spindles would see the vast majority of the IO.
> 

That's a good point - while I had noted that the OP was running a
database, I forgot it was a virtual windows machine and MS SQL database.
 The virtual machine will use a single large file for its virtual
harddisk image, and so RAID10 + XFS will beat RAID1 + concat + XFS.

On the other hand, he is also serving 100+ freenx desktop users.  As far
as I understand it (and I'm very happy for corrections if I'm wrong),
that will mean a /home directory with 100+ sub-directories for the
different users - and that /is/ one of the ideal cases for concat+XFS
parallelism.

Only the OP can say which type of access is going to dominate and where
the balance should go.


As a more general point, I don't know that you can generalise that
database workloads normally store data in a single big file or a small
set of files.  I haven't worked with many databases, and none more than
a few hundred MB, so I am theorising here on things I have read rather
than personal practice.  But certainly with postgresql the data is split
into multiple directories - each table has its own directory.  For very
big tables, the data is split into multiple files - and at some point,
they will hit the allocation group size and then be split over multiple
AG's, leading to parallelism (with a bit of luck).  I am guessing other
databases are somewhat similar.  Of course, like any database tuning,
this will all be highly load-dependent.





