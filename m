From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: RAID performance
Date: Thu, 7 Feb 2013 10:32:55 -0500
Message-ID: <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com>
References: <51134E43.7090508@websitemanagers.com.au>
	<CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
	<51137FB8.6060003@websitemanagers.com.au>
	<CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com>
	<5113A2D6.20104@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113A2D6.20104@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 7, 2013 at 7:49 AM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
>>
>> I definitely see that. See below for a FIO run I just did on one of my RAID10s
>>
>> md2 : active raid10 sdb3[1] sdf3[5] sde3[4] sdc3[2] sdd3[3] sda3[0]
>>       742343232 blocks super 1.2 32K chunks 2 near-copies [6/6] [UUUUUU]
>>
>> seq-read: (g=0): rw=read, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio,
>> iodepth=32
>> seq-write: (g=2): rw=write, bs=64K-64K/64K-64K/64K-64K,
>> ioengine=libaio, iodepth=32
>>
>> Run status group 0 (all jobs):
>>    READ: io=4096.0MB, aggrb=2149.3MB/s, minb=2149.3MB/s,
>> maxb=2149.3MB/s, mint=1906msec, maxt=1906msec
>>
>> Run status group 2 (all jobs):
>>   WRITE: io=4096.0MB, aggrb=1168.7MB/s, minb=1168.7MB/s,
>> maxb=1168.7MB/s, mint=3505msec, maxt=3505msec
>>
>> These drives are pretty fresh and my writes are a whole gig less than
>> my read. Its not for lack of bandwidth either.
>
> Can you please show your command line used, so I can try a similar test
> and see a comparison?
>

Seeing the 8MB second write in your other post you've definitely got
something bound up somewhere. You're going to want to get as low as
possible in your stack to verify the SSDs themselves are not the
issue. If you have extra unpartitioned space try testing against that.
You can just manually TRIM it afterwards to cleanup. If you can get
decent IO against a single device you've got something wrong higher
up. You'll have to find ways to test against each layer to find your
issue.

The tool I used is FIO: http://freecode.com/projects/fio

The benchmark was pretty simple. Save the following to a file, adjust
directory to where the test should write, and run it with ./fio
[file]. You may need to adjust the size parameter smaller if your
system will have trouble creating a 4g file. The filename option can
also be a device if the directory option is removed. Just be very
careful as the write test is destructive if done to a device instead
of a filesystem.

[global]
bs=64k
ioengine=libaio
iodepth=32
size=4g
direct=1
runtime=60
directory=/root
filename=ssd.test.file

[seq-read]
rw=read
stonewall

[seq-write]
rw=write
stonewall


--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
