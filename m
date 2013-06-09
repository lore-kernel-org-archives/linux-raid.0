From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 09 Jun 2013 17:40:16 -0400
Message-ID: <51B4F640.4030605@redhat.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com> <51B47088.4000501@redhat.com> <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/09/2013 04:06 PM, Steve Bergman wrote:
> Hello Ric,
>
> I was not intending to reply in this thread, for reasons I gave at the
> end of my previous post. However, since it is you who are responding
> to me, and I have a great deal of respect for you, I don't want to
> ignore this.
>
> Firstly, let me say that I do not care about winning an argument,
> here.  What I've said, I felt I should say. And it is based upon my
> best understanding of the situation, and my own experiences as an
> admin. If my statements seemed overly strong, then... well... I've
> found "Strong Opinions, Loosely Held" to be a good strategy for
> learning things I might not otherwise have discovered.
>
> I'm not a particular advocate or detractor for/against any particular
> filesystem. But I do strongly believe in discussing the relative
> advantages and disadvantaged, and in particular benefits and risks of
> filesystems and filesystem features frankly and honestly. The
> particular risks of a filesystem or feature should get have equal
> visibility to prospective users as to the benefits. There's no denying
> the XFS has a mystique. It's something I've noticed since that day in
> 1994 that the old SGI released the code under GPLv2. And if you did
> Google for "ZFS and zeroes" you surely noticed that many of the
> reports of trouble came from people who had no business using XFS in
> their environment in first place. And often based upon erroneous and
> incomplete information. And mixed in with those, there were folks who
> really thought they'd done their homework and still got bitten by one
> of the relative risks of "advanced and modern performance features". I
> believe that it is especially important for advocates of a filesystem
> to be forthright, honest, and frank about the relative risks. As doing
> otherwise hurts, in the long run, the reputation of the filesystem
> being advocated.
>
> Saying that "you can lose data with any filesystem" is true... but
> evasive, and misses the point. One could say that speeding down the
> interstate at 100mph on a motorcycle without a helmet isn't any more
> dangerous than driving a sedan with a "Five Star" safety rating at the
> speed limit, since after all, it's possible for people in the sedan to
> die in a crash, and there are even examples of this having happened.
> But that doesn't really address the issue in a constructive and honest
> way.

Hi Steve,

Specifically, ext4 and xfs behave exactly the same with regards to delayed 
allocation.

As I stated, pretty much without exception, people who monitor the actual data 
loss rates in shipping product have chosen to use XFS over ext4.  That is 
actual, tested deployed instances and backed up by careful monitoring.

I really don't care if you are a happy ext4 use - you should choose what you are 
comfortable and what gets the job done for you.

We (Red Hat we) work hard to make sure that all of the file systems we support 
handle power failure correctly and do regular and demanding tests on all of our 
file systems on a range of hardware types. We have full faith in both file systems.

Side note, we are also working to get btrfs up to the same standard and think it 
is closing in on stability.

>
> But enough of that. I've already said everything that I feel I'm
> ethically bound to say on that topic. And I'm interested in your
> thoughts on the topic of delayed allocation and languages which either
> don't support the concept of fsync, or in which the capability it
> little known and/or seldom used. e.g. Python. It does support the
> concept of fsync. But that's almost never talked about in Python
> circles. (At least to my knowledge.) The function is not a 1st class
> player. But fsync() does exist, buried in the "os" module of the
> standard library alongside dirname(), basename(), copy(), etc. My
> distro of choice is Scientific Linux 6.4. (Essentially RHEL 6.4.) And
> a quick find/fgrep doesn't reveal any usage of fsync at all in any of
> the ".py" files which ship with the distro. Perhaps the Python VM
> invokes it automatically? Strace says no. And this is in an enterprise
> distro which clearly states in its Administrator Manual sections on
> Ext4 & XFS that you *must* use fsync to avoid losing data. I haven't
> checked Ruby or Perl, but I think it's a pretty good guess that I'd
> find the same thing.

I don't know any details about Python, Ruby or Perl internals, but will poke 
around. Note that some of the standard libraries they call might also have 
buried calls in them to do the write thing with fsync() or fdatasync().
>
> However, I'd like to talk (and get your thoughts) about another
> language that doesn't support the concept of fsync. One that still
> maintains a surprising presence even today, particularly in
> government, but rarely gets talked about: COBOL. At a number of my
> sites, I have COBOL C/ISAM files to deal with. And at new sites that I
> take on, a common issue is that the filesystems have been mounted at
> the ext4 defaults (with delayed allocation turned on) and that the
> business has experienced data loss after an unexpected power loss, UPS
> failure, etc. (In fact *every* time I've seen this configuration and
> event I've observed data loss. The customer often just tacitly assumes
> this is just a flaw in the way Linux works. My first action is to
> mount nodelalloc, and this seems to do a great job of preventing
> future problems. In a recent event (last week) the Point of Sale line
> item file on a server was so badly corrupted that the C/ISAM rebuild
> utility could not rebuild it at all. Since this was new (and
> important) data which was not recoverable from the nightly backup, it
> involved 2 days worth of re-entering the data and then figuring out
> how to merge it with the PS data which had occurred during the
> intervening time.
>
> Is this level of corruption expected behavior for delayed allocation?
> Or have I hit a bug that needs to be reported to the ext4 guys? Should
> delayed allocation be the default in an enterprise distribution which
> does not, itself, make proper use of fsync? Should the risks of
> delayed allocation be made more salient than they are to people who
> upgrade from say, RHEL5 to RHEL6? Should options which trade data
> integrity guarantees for performance be the defaults in any case? As
> an admin, I don't care about benchmark numbers. But I care very much
> about the issue of data endangerment "by default".

I don't agree that data is at risk by default. The trade off of letting data 
accumulate in DRAM is *very* long standing (delayed allocation or not). Every 
database and serious application has dealt with this on a variety of operating 
systems for more than a decade.

If you have a bit of code that does the wrong thing, you can mount "-o sync" I 
suppose and crawl along safely but at painful slow speeds.

Regards,

Ric

>
> SIncerely,
> Steve Bergman
>
> P.S I very much enjoyed that "Future of Red Hat Enterprise Linux"
> event from Red Hat Summit 2012. While I don't necessarily advocate for
> any particular filesystem, I do find the general topic exciting. In
> fact, the entire suite of presentations was engaging and informative.

