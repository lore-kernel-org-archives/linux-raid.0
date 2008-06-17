From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: raid10,f2 degraded read speed
Date: Tue, 17 Jun 2008 16:37:45 +0200
Message-ID: <20080617143745.GA9148@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found this old message, from before I joined the list, in the
archives.

Jon Nelson wrote  2007-12-23 14:23:40 GMT:
> On 12/23/07, maobo <maobo1983 <at> gmail.com> wrote:
> > Hi,all
> >
> > Yes, I agree some of you. But in my test both using real life trace
> > and
> > Iometer test I found that for absolutely read requests, RAID0 is
> > better than
> > RAID10 (with same data disks: 3 disks in RAID0, 6 disks in RAID10). I
> > don't
> > know why this happen.
> >
> > I read the code of RAID10 and RAID0 carefully and experiment with
> > printk to
> > track the process flow. The only conclusion I report is the complexity
> > of
> > RAID10 to process the read request. While for RAID0 it is so simple
> > that it
> > does the read more effectively.
> >
> > How do you think about this of absolutely read requests?
> > Thank you very much!
> 
> My own tests on identical hardware (same mobo, disks, partitions,
> everything) and same software, with the only difference being how
> mdadm is invoked (the only changes here being level and possibly
> layout) show that raid0 is about 15% faster on reads than the very
> fast raid10, f2 layout. raid10,f2 is approx. 50% of the write speed of
> raid0.
> 
> Does this make sense?

I am not sure. What are the real figures? 50 % of the *degraded* write
speed? or normal wrute speed? Measured as actual on the disk or
effective in the file system?

degraded raid10,f2 read speed and write speed should be the same, eg on
a 2-disk setup.  And effectiveliy the rate should be like random IO on a
single disk. There should be no substantial difference between sequential
and random read nor write on a degraded raid10,f2.

Or maybe the elevator is making tricks?

-----

I also find it interesting that raid10,f2 should be 15 % slower than 
raid0 (given the same disk size, or half the disk size? Would the
raid10,f2 file system be say 500 GB and the raid0 1 TB?) - could that
be due to CPU overhead? It seems like the overhead is substantial, maybe
10 % on raid10,f2 while it is 0 % on raid0.

I only found a 3 % reduction (150 MB/s vs 155 MB/s) in my reported
benchmark for raid10,f2 vs raid0.

Justin Piszcz reported with a 6 disk setup a bonnie++ test for seq read:
                   kB/s    cpu
  raid0          286240   21.33
  raid10,f2      335520	  26.33

http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html

That is actually a 17 % improvement of raid10,f2 over raid0.

I repoted a teoretical overall improvement of 17 % of raid10,f2 compared to
raid0, due to disk geometry, and raid10,f2 only using half the space.

This bechmarks says 21 % cpu use for raid0, and 26 % cpu use for
raid10,f2. I wonder why all this pricessing is needed, and whether it
actually affects IO performance, or is actually carried out in parallel
with the IO.


----

I think I once found some benchmark (from Jon?) maybe on a Suse page
including various degraded raid10 arrays, even expressed in percentages
of normal one-disk performance. Can sombody provide a link?


Best regards
keld
