From: Joe Landman <joe.landman@gmail.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Wed, 27 Jul 2011 08:35:13 -0400
Message-ID: <4E300601.4070306@gmail.com>
References: <201107162140.58883.raid1@fuckaround.org>	<4E226464.2030200@hardwarefreak.com>	<ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>	<4E22D167.2010905@anonymous.org.uk> <CAEUYfyMEj31Gfy9KeT4sHWyUXcB-+9ehoZoXvHSXq6yztCzVXg@mail.gmail.com> <4E2FE6C9.4070604@hardwarefreak.com> <4E2FE7DF.1020906@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E2FE7DF.1020906@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/27/2011 06:26 AM, John Robinson wrote:
> On 27/07/2011 11:22, Stan Hoeppner wrote:
>> On 7/27/2011 12:42 AM, Simon Matthews wrote:
>>> On Sun, Jul 17, 2011 at 5:11 AM, John Robinson
>>> <john.robinson@anonymous.org.uk> wrote:
>>>
>>>> Pretty poor. CentOS 5, Intel ICH10, md RAID 6 over 5 7200rpm 1TB
>>>> drives,
>>>> then LVM, then ext3:
>>>> # dd if=/dev/zero of=test bs=4096 count=262144

no

	oflag=direct

or
	
	sync
	date
	dd if=/dev/zero of=test bs=4096 count=262144 ...
	sync
	date

and then a difference between the time stamps ...

>>>> 262144+0 records in
>>>> 262144+0 records out
>>>> 1073741824 bytes (1.1 GB) copied, 2.5253 seconds, 425 MB/s

This is purely file cache performance you have measured, nothing else.

[...]

> Gentlemen, we've been round this loop before about 10 days ago. Pol's 20
> MB/s was poor because he was testing on an array with unaligned

Using a huge blocksize (anything greater than 1/10th ram) isn't terribly 
realistic from an actual application point of view in *most* cases.  A 
few corner cases maybe, but not in most cases.

Testing on a rebuilding array gives you a small fraction of the 
available bandwidth ... typically you will see writes (cached) perform 
better than reads in these cases, but its not a measurement that tells 
you much more than performance during a rebuild.

Unaligned perform is altogether too common, though for streaming access, 
isn't normally terribly significant, as the first non-alignment access 
cost is amortized against many sequential accesses.  Its a bad thing for 
more random workloads.

> partitions and a resync was running, my 425 MB/s was a bad test because
> it didn't use fdatasync or direct and I said dd was a bad test anyway,
> etc etc.

dd's not a terrible test.  Its a very quick and dirty indicator of a 
problem in the event of an issue, if used correctly.  Make sure you are 
testing IO sizes of 2 or more times ram size, with sync's at the end, 
and use date stamps to verify timing.

bonnie++, the favorite of many people, isn't a great IO generator.  Nor 
is iozone, etc.  The best tests are ones that match your use cases. 
Finding these are hard.

We like fio, as we can construct models of use cases and run them again 
and again.  Cached, uncached, etc.  Makes for very easy and repeatable 
testing.



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
