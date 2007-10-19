From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 13:05:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan>
References: <18200.49267.763509.924873@stoffel.org>
 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>  <18200.53593.687483.120827@stoffel.org>
  <1192810534.1666.68.camel@firewall.xsintricity.com>  <18200.56684.14194.630264@stoffel.org>
  <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
 <18200.57042.989520.666476@stoffel.org>  <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
 <1192813477.1666.74.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192813477.1666.74.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 19 Oct 2007, Doug Ledford wrote:

> On Fri, 2007-10-19 at 12:45 -0400, Justin Piszcz wrote:
>>
>> On Fri, 19 Oct 2007, John Stoffel wrote:
>>
>>>>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>>>
>>> Justin> Is a bitmap created by default with 1.x?  I remember seeing
>>> Justin> reports of 15-30% performance degradation using a bitmap on a
>>> Justin> RAID5 with 1.x.
>>>
>>> Not according to the mdadm man page.  I'd probably give up that
>>> performance if it meant that re-syncing an array went much faster
>>> after a crash.
>>>
>>> I certainly use it on my RAID1 setup on my home machine.
>>>
>>> John
>>>
>>
>> The performance AFTER a crash yes, but in general usage I remember seeing
>> someone here doing benchmarks it had a negative affect on performance.
>
> I'm sure an internal bitmap would.  On RAID1 arrays, reads/writes are
> never split up by a chunk size for stripes.  A 2mb read is a single
> read, where as on a raid4/5/6 array, a 2mb read will end up hitting a
> series of stripes across all disks.  That means that on raid1 arrays,
> total disk seeks < total reads/writes, where as on a raid4/5/6, total
> disk seeks is usually > total reads/writes.  That in turn implies that
> in a raid1 setup, disk seek time is important to performance, but not
> necessarily paramount.  For raid456, disk seek time is paramount because
> of how many more seeks that format uses.  When you then use an internal
> bitmap, you are adding writes to every member of the raid456 array,
> which adds more seeks.  The same is true for raid1, but since raid1
> doesn't have the same level of dependency on seek rates that raid456
> has, it doesn't show the same performance hit that raid456 does.
>
>>
>> Justin.
> -- 
> Doug Ledford <dledford@redhat.com>
>              GPG KeyID: CFBFF194
>              http://people.redhat.com/dledford
>
> Infiniband specific RPMs available at
>              http://people.redhat.com/dledford/Infiniband
>

Got it, so for RAID1 it would make sense if LILO supported it (the 
later versions of the md superblock) (for those who use LILO) but for
RAID4/5/6, keep the bitmaps away :)

Justin.
