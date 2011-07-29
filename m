From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Fri, 29 Jul 2011 16:55:04 +0200
Message-ID: <j0uhk8$k9a$1@dough.gmane.org>
References: <4E25C9BA.1060401@dodtsair.com> <CABYL=TppzPDszVp3cr0DnuVDAg3Hjq2dvZyP0CYEz2x3H2ZjZQ@mail.gmail.com> <4E31AB58.3030206@redhat.com> <CABYL=To6GFBwsHi_2y6Rzgvr3LbP2Z9hUN8QjYP5Wf+vJtKsXw@mail.gmail.com> <4E32B5FE.6050001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E32B5FE.6050001@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/07/11 15:30, Doug Ledford wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 7/28/2011 3:46 PM, Roberto Spadim wrote:
>> hum make some benchmarks... about 4 months ago, i tested this with
>> korn andreas and we got not astronomical speed with write behind or
>> without it do you have some benchmarks to check?
>
> No, not yet, but I'll make some up.  The problem here is that the
> perceived speed increase is only really visible in certain situations.
> For example, if I'm building code, and repeatedly compiling, tweaking,
> compiling, tweaking, etc., then the entire set of code ends up in page
> cache and everything is done from memory, in which case the SSD makes no
> performance difference what so ever.  Any benchmark that operates
> entirely in cache will be a useless measure here.
>
> The biggest area where the SSD makes a difference is in reading pages
> into page cache.  Aka, cold cache reads.  You see this immediately on
> bootup for example.  My machine boots fast enough that it makes it to a
> login prompt before the ethernet device is done negotiating link speed
> and presents a link up to the networking layer (the fact that my
> workstation is Fedora 15 and uses upstart helps with this too, but on
> another machine without an SSD and with Fedora 15 I don't get to login
> prompt before ethernet link is up).  It also effects things like the
> startup speed of both Firefox and Thunderbird.  This is where the cold
> cache performance of an SSD helps.
>
> However, your question did get me started thinking and raised a few
> questions of my own (hence why I Cc:ed Neil).
>
> In order to do writemostly, you *must* use a write bitmap.  If you use
> an internal bitmap, it exists on all devices.  Normally, bitmap sets are
> done synchronously.  My question is: when one device is an SSD, do we
> only wait on the SSD bitmap update before starting the SSD writes, or do
> we wait on all the bitmap updates to complete before starting any of the
> writes?  If the later, could that be changed?  And as a general question
> about bitmap files instead of internal bitmaps, is it even possible to
> use an external bitmap file on the root filesystem given that no other
> filesystem is mounted in order to read a bitmap file prior to the root
> filesystem going live?  It would be nice to use an external bitmap file
> on the SSD itself and skip the internal bitmap I think.
>
> As a separate issue, I think a person could probably tweak a few things
> for an SSD in the general block layer too.  I haven't played with these
> things yet, but I plan to.  Things like changing the elevator to the
> noop elevator.
>
> Now, as for the differences between using an SSD like I am versus the
> two cache type uses that were brought up.
>
> The cache type usage has the benefit that it covers all the data on the
> drives even if the SSD is smaller than the drives.  Like any cache
> though, it can only hold the most commonly/frequently used items.  If
> your list of commonly used stuff is too large for the SSD, it will start
> to suffer cache misses and loose its benefit.  On writes though it can
> be very fast because it can simply buffer the write and then return to
> the OS as though the write is complete.  However, unless the caching
> implementation waits for at least one drive to acknowledge and complete
> the write (and especially if it accepts the write but only queues it up
> for write to the drives and then waits some period of time before
> flushing the write), then this represents a single point of failure that
> could cause (possibly huge amounts of) data loss.
>
> The setup I have essentially splits the data on my filesystem according
> to what I want cached.  I want applications so I get my performance
> boost on startup.  I want my source code repos so I can compile faster
> and do things like git checkouts faster.  But I don't need any mp3s or
> video files or rarely accessed documents on the SSD, so having a
> directory in my home directory to put all my stuff I want accessed fast
> and the rest of my home directory just on hard drive works perfectly
> well.  In my usage, if the SSD fails, then I don't have to worry about
> any data loss and the machine keeps chugging along.
>
> Anyway, about the benchmarks, I'll see what I can do over the weekend.
> Today, real work beckons ;-)
>

One thing has occurred to me while reading this thread - it seems to be 
an assumption here that SSD's are faster than HD's.  In one area - 
access times - SSD's are very much faster.  But when transferring bulk 
data, they are not necessarily faster.  Certainly a pair of good hard 
disks in RAID10,far will stream reads and writes with a similar 
throughput to many SSD's.  An ideal situation is therefore that small 
reads will come from the SSD, but that bulk reads could come from any 
disk that is currently idle.  Enabling "write-behind" on the hard disks 
would still be a big gain on the write latency.


