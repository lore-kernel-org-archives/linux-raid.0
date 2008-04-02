From: Beolach <beolach@gmail.com>
Subject: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10 raptors])
Date: Tue, 1 Apr 2008 22:26:11 -0600
Message-ID: <aebf5d970804012126o1e8a7d66qf80f081efcf0ec60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 29, 2008 at 12:20 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
<snip>
>
>  Results:
>  http://home.comcast.net/~jpiszcz/20080329-raid/
>
>  I have gone back to my RAID 5 optimized configuration, I am done testing
>  for now :)
>
>  __CREATION
>  1. Test RAID 10 with no optimizations to the disks or filesystems.
>     a. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid10 --raid-devices=10 --spare-devices=0 --layout=f2 /dev/sd[c-l]1
>     b. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid10 --raid-devices=10 --spare-devices=0 --layout=n2 /dev/sd[c-l]1
>     c. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid10 --raid-devices=10 --spare-devices=0 --layout=o2 /dev/sd[c-l]1
>  2. Test RAID 5 with no optimizations as well using the default layout.
>     a. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid5 --raid-devices=10 --spare-devices=0 /dev/sd[c-l]1
>  3. Test RAID 5 with optimizations.
>     a. mdadm --create /dev/md3 --assume-clean --chunk=1024 --level=raid5 --raid-devices=10 --spare-devices=0 /dev/sd[c-l]1
>
>  __SETUP
>  2. Format and set permissions and run benchmarks.
>     a. mkfs.xfs -f /dev/md3; mount /dev/md3 /r1; mkdir /r1/x
>        chown -R jpiszcz:users /r1
>
>  __TEST
>  3. Run the following bonnie++ benchmark 3 times and take the average.
>     a. /usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n 16:100000:16:64
>     b. A script will be responsible for running it 3 times and the total time
>        of all runs will also be taken.
>
<snip>

Thanks for sharing your benchmarking methods.  I've been running
similar benchmarks, trying to pick the best chunksize for my hardware,
and I also found your previous thread "Fastest Chunk Size w/XFS For MD
Software RAID = 1024k" in the archives.  In my benchmarks[1], I see
256k & 128k giving the best results.  So now I'm wondering if that's
just because I have different harddrives (Seagate ST31000340NS 1000GB
32MB cache), or if the number of drives is also important - I only
have 4 drives right now, but I plan on getting more when I can afford
to.  If I had more drives, would the larger chunksizes (512k or 1024k)
be more likely to perform better than 256k?

Also, would you be willing to share your script for averaging 3
bonnie++ runs?  I'm too lazy to write my own, so I've just been doing
single runs.

[1] My bonnie++ results:
<http://www.xmission.com/~beolach/bonnie++_4disk-ls.html>


Thanks,
Conway S. Smith
