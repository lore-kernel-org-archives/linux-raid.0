From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 9 Jun 2013 21:37:36 -0500
Message-ID: <CAO9HMNGQO55adys6f=s3fLRpEFbVYeLovXcSeXGAZOGLjdgXdA@mail.gmail.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
	<51B47088.4000501@redhat.com>
	<CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
	<loom.20130610T000503-316@post.gmane.org>
	<CAO9HMNGwdLG7ubNP1gC7To9pNstuwZPDAeV03HDkUjh5MWB0Dg@mail.gmail.com>
	<51B5178C.5050900@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B5178C.5050900@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jun 9, 2013 at 7:02 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

As I've posted previously, despite my best efforts and advice to
customers, I still have to deal with the results of unclean shutdowns.
And that is specifically what I am concerned about. If I've given the
impression that I don't trust xfs or ext4 in normal operation, it was
unintentional. I have the greatest confidence in them. I have
particularly recent experience with unclean shutdowns here in OKC. One
can say that I and the operating system are not responsible for the
unwise (or not so unwise) things that other people might do which
result in the unclean shutdowns. But ultimately, it is my
responsibility to do my level best, despite everything, to see that
data is not lost. It's my charge. And its what I'll do come hell, high
water, or tornadoes. And I do have a pragmatic solution to the problem
which has worked well for 3 years. But I'm open to other options.


> I don't recommend nodelalloc just because I don't know that it's thoroughly
> tested.

I can help a bit there. At least regarding this particular Cobol
workload, since it's a category that I've been running for about 25
years. The SysV filesystem of AT&T Unix '386 & 3B2, Xenix's
filesystem, SCO Unix 4.x's Acer Fast Filesystem, and ext2 all
performed similarly. Occasionally, file rebuilds were necessary after
a crash. SCO Open Server 5's HTFS did better, IIRC. I have about 12
years of experience with ext3. And I cannot recall a time that I ever
had data inconsistency problems. (Probably a more accurate way to put
it than "data loss".) It's possible that I might have had 1 or 2 minor
issues. 12 years is a long time. I might have forgotten. But it was a
period of remarkable stability. This is why when people say "Oh, but
it can happen under ext3, too!" it doesn't impress me particularly. Of
course it "could". But I have 12 years of experience by which to gauge
the relative likelihood.

Now, with ext4 at it's defaults, it was an "every time" thing
regarding serious data problems and unclean shutdowns, until I
realized what was going on. I can tell you that in 3 or using
nodelalloc on those data volumes, it's been smooth sailing. No
unexpected problems. For reasons you note, I do try to keep things at
the defaults as much as possible. That is generally the safe and best
tested way to go. And it's one reason I don't go all the way and use
data=journal. I remember one reports, some years ago, where ext3 was
found to have a specific data loss issue... but only for people
mounting it data=journal.

But regarding nodelalloc not providing perfect protection...
"perfection" is the enemy of "good". I'm a pragmatist. And nodelalloc
works very well, while still providing acceptable performance, with no
deleterious side-effects. At least in my experience, and on this
category of workload, I would feel comfortable recommending it to
others in similar situations, with the caveat that YMMV.


> You probably need to define what _you_ mean by resiliency.

I need for the metadata to be in a consistent state. And for the data
to be in a consistent state. I do not insist upon that state being the
last state written to memory by the application. Only that the
resulting on-disk state reflect a valid state that the in-memory image
had seen at some time, even for applications written in environments
which have no concept of fsync or fdatasync, or where the program
(e.g. virt-manager or cupsd) don't do proper fsyncs. i.e. I need ext3
data=ordered behavior. And I'm not at all embarrassed to say that I
need (not want) a pony. And speaking pragmatically, I can vouch for
the fact that my pony has always done a very good job.

> Anything else you want in terms of data persistence (data from my careless
> applications will be safe no matter what) is just wishful thinking.

Unfortunately, I don't have the luxury of blaming the application.

> ext3 gave you about 5 seconds thanks to default jbd behavior and
> data=ordered behavior.  ext4 & xfs are more on the order of
> 30s.

There's more to it than that, though, isn't there? Ext3 (and
presumably ext4 without DA) flush the relevant data immediately before
the metadata write. It's more to do with metadata and data being
written at the same time (and data just *before* metadata) than of the
frequency with which it happens. Am I correct about that?

> But this all boils down to:>
> Did you (or your app) fsync your data?

No. Because Cobol doesn't support it. And few, apparently not even Red
Hat, bothers to use the little known os.fsync() call under Python, so
far as I've been able to tell. Still haven't checked on Perl and Ruby.

> (It'd probably be better to take this up on the filesystem lists,
> since we've gotten awfully off-topic for linux-raid.

I agree that this is off-topic. It started as a relevant question
(from me) about odd RAID10 performance I was seeing. Someone decided
to use it as an opportunity to sell me on XFS, and things went south
from there. (Although I have found it to be interesting.) I wasn't
going to post further here. I'd even unsubscribed from the list.  But
I couldn't resist when you and Ric posted back. I know that you both
know what you're talking about, and give honest answers, even if your
world of pristine data centers and mine of makeshift "server closets"
may result in differing views. I have a pretty good idea the way
things would go were I to post on linux-fsdevel. I saw how that all
worked out back in 2009. And I'd as soon not go there. I think I got
all the answers I was looking for here, anyway. I know I asked a
couple of questions of you in this post. But we can keep it short and
then cut it short, after.

Thanks for your time and your thoughts.

-Steve Bergman
