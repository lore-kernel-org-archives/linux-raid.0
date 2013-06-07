From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 7 Jun 2013 05:44:00 -0500
Message-ID: <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
	<CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
	<CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stan, Roger, Alexander,

Thanks for the helpful posts. After posting, I decided to study up a
bit on what SATA 3Gb/s actually means. It turns out that the 3Gbit/s
bandwidth is aggregate per controller. This is a 4-port SATA
controller, so with 1 drive, the single drive gets all 3Gbit/s. With 4
operating simultaneously, each would get 750Mbit/s. There is supposed
to be about a 20% overhead involved in the SATA internals, so that
number drops to ~600Mbit/s. This is 75MByte/s, which is about what I'm
seeing on writes. For reads, I would expect to see ~300MBytes/s, and
am seeing 260MBytes/s, which is not too far off.

This is not really a problem for me, as the workloads I'm concerned
about are seekier than this, and are not bandwidth limited. (e.g.
Rebuilding indexes of Cobol C/ISAM files, and it's doing well on
that.) Mainly, I just wanted to make sure that this wasn't an
indication that I was doing something wrong, and to see if maybe there
was something to be learned here (which there was). Bonnie++ does
report that the RAID10 is doing ~2x the number of seeks/s as the
single-drive configuration. I'll be comparing the results of "iozone
-ae" between single-drive and RAID10 later today, to get a more
fine-grained view of the relative write performance.

BTW Stan, for ext4 stride and stripe-width are specified in filesystem
blocks rather than in K. In this case, I'm using the default 4k block
size. So stride should be:

chunksize / blocksize = 512k / 4k = 128

and the stripe-width should be:

stride * number of mirrored sets

In this case, I have 2 mirrored sets. So stripe-width should be 128 * 2 = 256.

-Steve Bergman

On Fri, Jun 7, 2013 at 3:07 AM, Alexander Zvyagin
<zvyagin.alexander@gmail.com> wrote:
>> And it is also possible that running more disks at the same time
>> cannot be sustained by the on-board chipset.
>
> to check this, start "dd" or "badblocks" or something similar (which
> will put disk to 100% load) on all your drives one-by-one and monitor
> throughput with "iostat" (or similar). Yam may face the following
> 'problem':
> 1. start badblocks on /dev/sda, throughput is 140 MB/s
> 2. start badblocks on /dev/sdb, throughput is 140 MB/s on /dev/sda and /dev/sdb
> 3. start badblocks on /dev/sdc, throughput is 140 MB/s on /dev/sda and
> 70 MB/s on /dev/sdb,/dev/sdc
>
> Alexander
