From: Nicolas Noble <nicolas@nobis-crew.org>
Subject: Failure propagation of concatenated raids ?
Date: Tue, 14 Jun 2016 14:43:27 -0700
Message-ID: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

  I have a somewhat convoluted question, which may take me some lines
to explain, but the TL;DR version of it is somewhat along the lines of
"How can I safely concatenate two raids into a single filesystem, and
avoid drastic corruption when one of the two underlying raids fails
and goes read only ?" I have done extensive research about that, but I
haven't been able to get any answer to it.

  My basic expectation when using raids is that if something goes
wrong, the whole thing goes read-only in order to prevent any further
damage by writing inconsistent or incomplete metadata. At that point,
human intervention can try and recover the raid. If the damage was
caused by partial power failure, or simply a raid controller which
died, recovery is usually fairly straightforward, with little to no
errors, and filesystem checks, for the last few writes that failed to
get committed properly. This works well when having a simple 1:1 path
between the raid and the filesystem (or whichever process that is
using the md device), but if I'm trying anything outside that simple
path, not everything turns read only and the kernel will happily
continue writing to half of its filesystem, and heavy filesystem
corruption may occur over the course of time between when the failure
starts and human intervention begins shutting down everything.

  Here's a reproducible scenario that explains what I'm talking about,
using approximately 100MB of disk space.

0. Setting up 8x10MB loopback devices:

# dd if=/dev/zero of=mdadm-tests bs=10240 count=$((10*1024))
10240+0 records in
10240+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.121364 s, 864 MB/s
# for p in `seq 1 8` ; do sgdisk -n $p:+0:+10M mdadm-tests ; done > /dev/null
# kpartx -a -v -s mdadm-tests
add map loop2p1 (254:7): 0 20480 linear 7:2 2048
add map loop2p2 (254:8): 0 20480 linear 7:2 22528
add map loop2p3 (254:9): 0 20480 linear 7:2 43008
add map loop2p4 (254:10): 0 20480 linear 7:2 63488
add map loop2p5 (254:11): 0 20480 linear 7:2 83968
add map loop2p6 (254:12): 0 20480 linear 7:2 104448
add map loop2p7 (254:13): 0 20480 linear 7:2 124928
add map loop2p8 (254:14): 0 20480 linear 7:2 145408



1. The typical, properly working, situation, 1 raid device, 1 process:

First, creating the raid, and "formatting it" (writing zeroes on it):
# mdadm --create test-single --raid-devices=8 --level=5
/dev/mapper/loop2p[12345678]
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/test-single started.
# mdadm --detail /dev/md/test-single | grep State.:
         State : clean
# shred -v -n0 -z /dev/md/test-single
shred: /dev/md/test-single: pass 1/1 (000000)...

We can then "read" the device properly, and grab a status:
# md5sum /dev/md/test-single
764ae0318bbdb835b4fa939b70babd4c  /dev/md/test-single

Now we fail the raid device by pulling two drives out of it:
# mdadm /dev/md/test-single --fail /dev/mapper/loop2p[78]

We can see that the raid has successfully be put in failed mode:
# mdadm --detail /dev/md/test-single | grep State.:
         State : clean, FAILED

Now we can try writing to it with random data, but it'll produce a lot
of write errors:
# shred -n1 /dev/md/test-single 2> /dev/null

We stop the raid, examine it, repair it, and re-assemble it:
# mdadm --stop /dev/md/test-single
mdadm: stopped /dev/md/test-single
# mdadm --assemble test-single -f /dev/mapper/loop2p[1234567]
mdadm: forcing event count in /dev/mapper/loop2p7(6) from 18 upto 38
mdadm: clearing FAULTY flag for device 6 in /dev/md/test-single for
/dev/mapper/loop2p7
mdadm: Marking array /dev/md/test-single as 'clean'
mdadm: /dev/md/test-single has been started with 7 drives (out of 8).

And we can start recovering data - nothing changed, as basically
expected in that scenario:
# md5sum /dev/md/test-single
764ae0318bbdb835b4fa939b70babd4c  /dev/md/test-single


Preparing for the next round of commands:

# mdadm --stop /dev/md/test-single
mdadm: stopped /dev/md/test-single
# for p in `seq 1 8` ; do shred -n0 -z -v /dev/mapper/loop2p$p ; done
shred: /dev/mapper/loop2p1: pass 1/1 (000000)...
shred: /dev/mapper/loop2p2: pass 1/1 (000000)...
shred: /dev/mapper/loop2p3: pass 1/1 (000000)...
shred: /dev/mapper/loop2p4: pass 1/1 (000000)...
shred: /dev/mapper/loop2p5: pass 1/1 (000000)...
shred: /dev/mapper/loop2p6: pass 1/1 (000000)...
shred: /dev/mapper/loop2p7: pass 1/1 (000000)...
shred: /dev/mapper/loop2p8: pass 1/1 (000000)...



2. Concatenating two raids, or when things fail hard:

First, let's create two raids, of different sizes:
# mdadm --create test-part1 --raid-devices=3 --level=5 /dev/mapper/loop2p[123]
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/test-part1 started.
# mdadm --create test-part2 --raid-devices=5 --level=5 /dev/mapper/loop2p[45678]
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/test-part2 started.

Then, let's create a super-raid made of these two. Note that this can
also be done using lvm2, with similar results.
# mdadm --create supertest --level=0 --raid-devices=2 /dev/md/test-part[12]
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/supertest started.

As before, we "format" it (write zeroes to it), and we read it:
# shred -n0 -z -v /dev/md/supertest
shred: /dev/md/supertest: pass 1/1 (000000)...
# md5sum /dev/md/supertest
57f366e889970e90c22594d859f7847b  /dev/md/supertest

Now, we're going to fail only the second raid, again by pulling two
drives out of it:
# mdadm /dev/md/test-part2 --fail /dev/mapper/loop2p[78]

And here's really the issue I have: the failure doesn't cascade to the
superset of the two above:
# mdadm --detail /dev/md/test-part1 | grep State.:
         State : clean
# mdadm --detail /dev/md/test-part2 | grep State.:
         State : clean, FAILED
# mdadm --detail /dev/md/supertest | grep State.:
         State : clean

Not that it seems that it could, as failing a raid0 drive isn't
supposed to work, which kind of bothers me:
# mdadm /dev/md/supertest --fail /dev/md/test-part2
mdadm: set device faulty failed for /dev/md/test-part2:  Device or resource busy

So, when we try writing random data to the raid, a good portion of the
writes are being refused with write errors, but the ones on the first
raid are making it through:
# shred -n1 /dev/md/supertest 2> /dev/null

Now, if we try recovering our cascading raids as before...
# mdadm --stop /dev/md/supertest
mdadm: stopped /dev/md/supertest
# mdadm --stop /dev/md/test-part2
mdadm: stopped /dev/md/test-part2
# mdadm --assemble test-part2 -f /dev/mapper/loop2p[4567]
# mdadm --assemble supertest -f /dev/md/test-part[12]
mdadm: /dev/md/supertest has been started with 2 drives.

... then its content has changed:

# md5sum /dev/md/supertest
78a213cbc76b9c1f78e7f35bc7ae3b73  /dev/md/supertest

And upon inspecting it further (using a simple hexdump -C on the
device), one can see that the whole of the first raid has been filled
with data, while the second one is still fully empty - it's not just a
few lingering writes that were pending before the failures.


  As said during this quite long log, concatenating the two raid
devices by putting them into the same volume group using lvm2 instead
of trying to create a raid0 will yield the same kind of results,
albeit a bit different: with a raid0 on top of the two raid5, one can
see the damage as stripes of interlaced data, which makes sense given
the way data is being organized in a raid0. With the lvm2
concatenation, you would instead get two big chunks: one with the
altered content of raid1, and one with the original content of raid2,
which also makes sense given the way lvm2 organizes its data.
Concatenating raids using lvm2 seems more natural, but I would expect
both mechanisms to behave the same way.

  Now, the above log is shrunk down drastically, but is inspired by
real events, where a portion of a ~40TB filesystem turned read only
because of a controller failure, and went unnoticed for several hours
before the kernel turned the filesystem readonly after detecting an
inconsistency failure in the filesystem metadata. After rebooting, the
filesystem was so much corrupted that mounting it in emergency mode
was barely possible, and it took several days of quite painful
recovery process, involving tape backups. I strongly believe that said
recovery process would've been much faster / easier if the whole of
the filesystem turned readonly when one of its two portion failed.

  So, after this quite long demonstration, I'll reiterate my question
at the bottom of this e-mail: is there a way to safely concatenate two
software raids into a single filesystem under Linux, so that my basic
expectation of "everything goes suddenly read only in case of failure"
is being met ?

  Thanks
