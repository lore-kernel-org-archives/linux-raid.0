From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 07 Jun 2013 18:33:14 -0500
Message-ID: <51B26DBA.2030009@hardwarefreak.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com> <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com> <CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com> <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com> <20130607165236.60ac7451@natsu> <CAO9HMNG2M7KDke3A0c06G47kvVWgssu7ur47BN=0goc2ELDhKQ@mail.gmail.com> <51B1DD93.1010904@hardwarefreak.com> <CAO9HMNG0-hhgj1V+8yVe6F_mqsRAiJgZf+06vo-Pt0BUEYjS0A@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNG0-hhgj1V+8yVe6F_mqsRAiJgZf+06vo-Pt0BUEYjS0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/7/2013 8:54 AM, Steve Bergman wrote:
> This is Scientific Linux (RHEL) 6.4. That's nominally kernel 2.6.32,
> but that doesn't tell one much. The RHEL kernel is the RHEL kernel,
> with features selected from far more recent kernels included, more
> being added with every point release. (e.g., I have the dm-thin target
> available in LVM2.)

Yeah, Red Hat marches to the beat of their own drummer.  Their version
string is meaningless.  They have newer kernel features in their 2.6.32
that rely on features only available in later upstream kernels, that
can't be backported to 2.6.32. Thus the core kernel isn't based on 2.6.32.

> I've used both CFQ and Deadline for testing. It doesn't make a
> measurable difference for either the multiple dd's or for the
> single-threaded C/ISAM rebuild. (In fact, deadline, while often better
> for servers, can have problems with mixed sequential/random access
> workloads. At least according to what I've seen over on the PostgreSQL
> lists. It's no surprise that deadline doesn't help my single-threaded
> workload. Also note that deadline has shown itself to be slightly
> superior to noop for SSD's in certain benchmarks.) There's no one size
> fits all answer. Until the particular workload is actually tested, it
> *is* guesswork. I/O scheuling is too complicated for it to be
> otherwise.

Caveat:  I'm an XFS user.  CFQ simply gives sub par to horrible
performance with XFS, regardless of workload or hardware.  The upstream
developers haven't supported XFS on CFQ for many years.  Because of
things like the note at the bottom of this FAQ entry:
http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

Considering one of, if not the, main reasons for using XFS is parallel
IO, this speaks volumes about CFQ's suitability for high performance
workloads.

> The chipset supports AHCI, but unfortunately it's turned off on the

Wow.  A huge Intel partner castrating their integrated SATA controllers.

> PET310, and the setting is not exposed in the BIOS setup, despite the
> fact that Dell advertises AHCI capability. It would do AHCI if I
> bought one of the optional SAS controllers.

Interesting.  SAS controllers typically don't use the AHCI interface.
In fact I know of none.  Dell uses LSISAS ASICs on their SAS cards and
mobo down on servers, and these use the LSI mptsas driver, not AHCI.

> Since this is an unusual RAID10 situation, and I have plenty of spare
> processor available, I'm going to try RAID5 over the weekend. I've
> never used it. But I'm guessing that parity might come at a lower
> bandwidth cost than mirroring. Should be a fun weekend. :-)

If you're looking for increased performance look elsewhere.  RMW latency
typically gives you random write throughput about 1/3rd to 1/5th that of
RAID10 with the same drive count.  Sequential read may be slightly
faster than vanilla RAID10.  However, as many are fond of mentioning,
using the far layout can get you sequential read close to that of pure
striping, so it'll be faster than RAID5 all around.  There never has
been and never will be a performance advantage for RAID5, unless you're
using SSDs where RMW latency is effectively zero.

> BTW, any recommendations on chunk size?

32KB works well for just about any workload.  Exceptions would be HPC or
media server workloads where you're writing files 10s of GB to TB in
size, especially in parallel.

-- 
Stan

