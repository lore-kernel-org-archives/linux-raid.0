From: "Christian Pernegger" <pernegger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: md-raid5, dm-crypt, alignment and readahead
Date: Mon, 10 Mar 2008 17:10:29 +0100
Message-ID: <bb145bd20803100910l6cfe250bs631184b493a23e04@mail.gmail.com>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-return-2644-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
Content-Disposition: inline
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-crypt-4q3lyFh4P1g@public.gmane.org
List-Id: linux-raid.ids

Hi!

Since the original thread has gotten rather long and convoluted,
mostly because I've been barking up a few wrong trees, I'd like to
start a new one and welcome the dm-crypt people aboard at the same
time.


HARDWARE:

Tyan Thunder K8W (S2885)
Dual Opteron 254, 2GB (2x2x512MB) DDR333 ECC RAM
Adaptec 29160 with 1x Maxtor Atlas 15K II (system disk)
Dawicontrol DC-4320 RAID with 4x WD RE2-GP 1TB

The Dawicontrol is a 4-port SATA2 PCI-X card using a Silicon Image
3124 chip with sata_sil24 driver. According to its datasheet the cards
maximum total throughput is 300MB/s, which I have confirmed
empirically. TCQ is enabled and works flawlessly as far as I can tell.
The WD RE2-GBs can do ~75MB/s reads or writes at their very beginning
- of course it goes down from there.
The Opterons' crypto performance is ~100MB/s for aes-256-cbc.


SOFTWARE:

Debian testing-amd64
linux-image-2.6.22-3-amd64
e2fsprogs 1.40.6-1
mdadm 2.6.4-1
cryptsetup 2:1.0.6~pre1+svn45-1
aes-x86_64 module


SETUP

1. md only
After some extensive benchmarking I have decided to create a md-RAID5
across the 4 disks with 1MB chunk size and 512MB bitmap chunk size
(internal).
/sys/block/md0/md/stripe_cache_size = 8192   (Maybe further increase
would help, I haven't tested this much. FWIW I haven't seen
stripe_cache_active full yet.)
readahead set to 0 for the component devices and 2 full stripes = 6MB
= 12288 sectors for the md device via blockdev --setra. NOTE: dm-crypt
is not involved yet.

Tested with "sync; echo 3 > /proc/sys/vm/drop_caches; dd of=/dev/null
if=/dev/md0 bs=3145728 count=2730" and averaged over 3 runs:

Reads: 274MB/s
- that's 91% of reading from the four disks in parallel
- larger readahead does not bring any improvement
- iostat shows that during reads the load is evenly distributed over
the component disks and there aren't any writes.

Writes: 182MB/s
- that's 81% of the write performance of 3 disks in parallel
- iostat shows that during writes the load is evenly distributed over
the component disks, but also that there are *reads* going on in
parallel, if slowly. Why is that? The dd block size should be a full
stripe and in any case large enough to be combined into one. When I do
some badly misaligned writes on purpose the "MB_read/s" values are
about 10-15 times higher, so it's not raid5 read-modify-write cycles,
but what is it reading?

Sample output of iostat -m 2:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
                0,00      0,00    45,02      0,00       0,00   54,98

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb             238,12         1,00        57,72              2        116
sdc             250,50         2,24        57,93              4        117
sdd             136,14         2,05        56,43              4        113
sde             202,97         1,74        54,71              3        110
md0           42650,99      0,00       166,61             0        336

Additionally, for both reads and writes the tps ("transfers per
second") seems strange. The component disks have ~4 transfers / MB /
second (write) and ~3 transfers / MB / second (read), while the md
device has ~ 256 transfers / MB / second (write and read). Is this
normal? Well, maybe these "transfers" are combined later anyway, but
I'd have expected mds tps to be 3-4 times that of a component disk.


2. md + dm-crypt
Since I was getting nice performance on the RAID, even though I
obviously can't interpret iostat, I decided to go on to the dm-crypt
layer.

That raised the dreaded question of alignment. In theory telling
cryptsetup to align at chunk boundaries (= 1MB = 2048 sectors) should
do the trick. There should be no need to align to stripe boundaries
because it doesn't matter if a full-stripe-write is [d0 -> d1 -> d2 ->
d3] or f. ex. [d2 -> d3 -> d0 -> d1]. Testing this with the same
method as above I got:

ALIGN (KB)   read (MB/s)   write (MB/s)
1024             113               131               # chunk
3072             114               133               # stripe
4096             116               132               # nicer multiple of chunk
4                   115               130               # default alignment
81                  83                  80               # cruel mis-align

If it weren't for the last case I'd have doubts the --align-payload
option does anything at all. Especially the fact that not giving an
explicit alignment doesn't hurt is strange. Of course the requests
could be merged somewhere so that most still result in a
full-stripe-write but then the same should result for the pathological
case-81, shouldn't it? Oh and why does mis-alignment kill *reads* as
well?

Next up, readahead:

Is there a difference between running blockdev --setra and echo-int to
/sys/block/.../read_ahead_kb for devices that have the entry in /sys?
How is readahead handled when "stacked" virtual block devices are
involved? Does only the top layer count, does each layer read ahead
for itself and if it does is the data used at all?

In theory it would make sense to have md read ahead but not dm-crypt,
because decrypting block that turn out not to be needed is
ridiculously expensive. That way the encrypted blocks would be read
ahead into the page cache and dm-crypt could get them from there when
needed. Only I don't know if it works that way at all and dd /
sequential I/O is not a benchmark suited for a test.

Considering the past reports on dm-crypt-on-md data corruption - what
is a good data corruption test I can leave running for a few days and
at least hope that everything is fine if it passes?

Thanks for reading this far :-)

Cheers,

C.
