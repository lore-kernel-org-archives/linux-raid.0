From: Marc MERLIN <marc@merlins.org>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 23 Jan 2014 13:01:55 -0800
Message-ID: <20140123210155.GJ10046@merlins.org>
References: <20140122174854.GF26014@merlins.org> <52E051A3.3050103@hardwarefreak.com> <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21217.9977.5869.747472@quad.stoffel.home> <52E10A07.3070302@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 23, 2014 at 06:24:39AM -0600, Stan Hoeppner wrote:
> > In case you don't believe me, I just switched my drives from the PMP to
> > directly connected to the motherboard and a marvel card, and my rebuild
> > speed changed from 19MB/s to 99MB/s.
> > (I made no other setting changes, but I did try your changes without
> > saving them before and after the PMP change and will report below)
> 
> Why would you assume I wouldn't believe you?
 
You seemed incredulous that PMPs could make things so slow :)

> > Thanks for that one.
> > It made no speed difference on the PMP or without, but can't hurt to do anyway.
> 
> If you're not writing it won't.  The problem here is that you're
> apparently using a non-destructive resync as a performance benchmark.
> Don't do that.  It's representative of nothing but read-only resync speed.
 
Let me think about this: the resync is done at build array time.
If all the drives are full of 0's indeed there will be nothing to write.
Given that, I think you're right.

> Increasing stripe_cache_size above the default as I suggested will
> ALWAYS increase write speed, often by a factor of 2-3x or more on modern
> hardware.  It should speed up destructive resyncs considerably, as well
> as normal write IO.  Once your array has settled down after the inits
> and resyncs and what not, run some parallel FIO write tests with the
> default of 256 and then with 2048.  You can try 4096 as well, but with 5
> rusty drives 4096 will probably cause a slight tailing off of
> throughput.  2048 should be your sweet spot.  You can also just time a
> few large parallel file copies.  You'll be amazed at the gains.

Will do, thanks.

> The reason is simply that the default of 256 was selected some ~10 years
> ago when disks were much slower.  Increasing this default has been a
> topic of much discussion recently, because bumping it up increases
> throughput for everyone, substantially, even with 3 disk RAID5 arrays.

Great to hear that the default may hopefully be increased for all.
 
> > As you did point out, the array will be faster when I use it because the
> > encryption will be sharded over my CPUs, but rebuilding is going to create 5 encryption
> > threads whereas if md5 is first and encryption is on top, rebuilds do
> > not involve any encryption on CPU.
> > 
> > So it depends what's more important.
> 
> Yep.  If you post what CPU you're using I can probably give you a good
> idea if one core is sufficient for dmcrypt.

Oh, I did forget to post that.

That server is a low power-ish dual core with 4 HT units:
processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i3-2100T CPU @ 2.50GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 2500.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt tsc_deadline_timer xsave avx lahf_lm arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5150.14
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

> I'll also reiterate that encrypting a 16TB array device is silly when
> you can simply carve off an LV for files that need to be encrypted, and
> run dmcrypt only against that LV.  You can always expand an LV.  This is
> a huge performance win for all other files, such your media collections,
> which don't need to be encrypted.

I use btrfs for LV management, so it's easier to encrypt the entire pool. I
also encrypt any data on any drive at this point, kind of like I wash my
hands. I'm not saying it's the right thing to do for all, but it's my
personal choice. I've seen too many drives end up on ebay with data, and I
don't want to have to worry about this later, or even erasing my own drives
before sending them back to warranty, especially in cases where maybe I
can't erase them, but the manufacturer can read them anyway.
You get the idea...

I've used LVM for too many years (15 was it?) and I'm happy to switch away now :)
(I know thin snapshots were recently added, but basically I've been not
super happy with LVM performance, and LVM snapshots have been abysmal if you
keep them long term).
Also, this is off topic here, but I like the fact that I can compute snapshot diffs
with btfrs and use that for super fast backups of changed blocks instead of a very slow rsync
that has to scan millions of inodes (which is what I've been doing so far).

> >> Question #2:
> >> In order to copy data from a working system, I connected the drives via an external
> >> enclosure which uses a SATA PMP. As a result, things are slow:
> >>
> >> md5 : active raid5 dm-7[5] dm-6[3] dm-5[2] dm-4[1] dm-2[0]
> >>       15627526144 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UUUU_]
> >>       [>....................]  recovery =  0.9% (35709052/3906881536) finish=3406.6min speed=18939K/sec
> >>       bitmap: 0/30 pages [0KB], 65536KB chunk
> >>
> >> 2.5 days for an init or rebuild is going to be painful.
> 
> With stripe_cache_size=2048 this should drop from 2.5 days to less than
> a day.

It didn't since it PMP limited, but I made that change for the other reasons
you suggested.

> > Still curious on this: if the drives are brand new, is it safe to assume
> > t> hey're full of 0's and tell mdadm to skip the re-init?
> > (parity of X x 0 = 0)
> 
> No, for a few reasons:
> 
> 1.  Because not all bits are always 0 out of the factory.
> 2.  Bad sectors may exist and need to be discovered/remapped
> 3.  With the increased stripe_cache_size, and if your CPU turns out to
> be fast enough for dmcrypt in front of md, resync speed won't be as much
> of an issue, eliminating your motivation for skipping the init.
 
All fair points, thanks for explaining.
For now, I put dmcrypt on top of md5, I get 100MB/s raw block write speed (actually
just writing a big file in btrfs and going through all the layers) even
though it's only using one CPU thread for encryption instead of 2 or more if
each disk were encrypted under the md5 layer.

Since 100MB/s was also the resync speed I was getting without encryption
involved, looks like a single CPU thread can keep up with the raw IO of the
array, so I guess I'll leave things that way.
As another test
gargamel:/mnt/btrfs_pool1# dd if=/dev/md5 of=/dev/null bs=1M count=1024
1073741824 bytes (1.1 GB) copied, 9.78191 s, 110 MB/s

So it looks like 100-110MB/s is the read and write speed limit of that array.
The drives are rated for 150MB/s each so I'm not too sure which limit I'm
hitting, but 100MB/s is fast enough for my intended use.

Thanks for you answers again,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
