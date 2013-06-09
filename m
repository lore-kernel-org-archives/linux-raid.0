From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 9 Jun 2013 18:08:19 -0500
Message-ID: <CAO9HMNG8TaG3oTtmOcv8Zhe7_XghAzLLyEF5JwTpBAJfxhe+Qw@mail.gmail.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
	<51B47088.4000501@redhat.com>
	<CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
	<51B4F640.4030605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B4F640.4030605@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello, and thank you for the response.

Firstly, while I am a happy ext4 user, I would prefer not to be
defined by that. I'm not about filesystem A is better than filesystem
B. I'm very much in accord with Ted Ts'o's "horses for courses"
philosophy on the issue of filesystem selection.

However, this reminds me that I meant to ask specifically, since XFS
is on my list of filesystems that I consider for various use-cases,
about the relative integrity guarantees provided. In a situation where
I would be comfortable using ext4 with journal=writeback mode and
leaving delayed allocation turned on, I should get the same level of
data integrity with XFS, right? Or is there any difference, either
way? What about comparing ext4 with delayed allocation on or off, or
data=writeback, or other combinations? Is it possible to change the
level of guarantee I get from XFS? I ask because It's entirely
possible that there's something important that I happen not to know
about it.

Understand that the servers I administer are not sitting in data
centers. They are sitting in offices in small to medium sized
businesses with maybe 100 - 150 employees, generally family-owned and
pretty informal, without me there to watch over. (I'm an independent
consultant.) And there are inevitable situations like last week when
there was a(nother) power failure (I live in Oklahoma City) and the
management and employees were scrambling to put everything on
generators. The UPS didn't like the generator, and by the time they
got the server back up it had crashed 5 times. And I don't even find
out about these things until after the fact. And no matter what I do
or advise to prevent these kinds of things, there's always something
else that goes wrong. I may not be one of your "enterprise customers",
but I'm surely not alone. This may all seem a bit "Green Acres" to
you, but it's the reality I live in. And I can't force my customers to
act on my advice if they opt not to. But regardless of everything,
it's still my responsibility as a consultant, not to mention a Linux
advocate, to protect my customers' data, and to ensure that Linux
doesn't get the reputation for losing data. NCR would be more than
happy to move these people from their current Linux product to their
newer Windows-only "upgraded" version. Their marketing department is
certainly trying hard enough.

You may have your enterprise statistics. But I have a set of pretty
compelling personal experiences over the past 4 years which differs
substantially. Anecdotal, yes. But they're *my* anecdotes, which makes
a difference to me.

> Note that some of the standard libraries they call might also have buried calls in them to do the write thing with fsync() or fdatasync().

I just chose an application at random to look at. I opened up
virt-manager under "strace -o virtman.out -f", and created a new VM.
At no time was fdatasync() called. There was a single call to fsync()
on file "/root/.config/gtk-2.0/gtkfilechooser.ini.5ZESYW". I'd have
expected a number of key libvirtd config files to have been fsync'd or
fdatasync'd.

> If you have a bit of code that does the wrong thing, you can mount "-o sync" I suppose and crawl along safely but at painful slow speeds.

Sarcasm noted. ;-) I find that in practice, simply leaving the data
volumes in data=ordered mode and turning off DA results in -osync-like
data integrity.  I've considered data=journal. But even though I'm not
a RH customer, I like to abide by RH support guidelines (on the
assumption that you guys might be aware of some pitfalls of which I am
blissfully ignorant). And the Administration Manual implies that
data=journal is not an officially supported journaling mode. (Why?) I
think we can agree that "-osync" would be both unnecessary and
overkill for almost any situation.

At any rate, this conversation, and the fact that
/etc/cups/printers.conf turned up zero-length after the emergency last
week, are really piquing my curiosity about just how well OS vendors
who say "just use fsync" are following their own advice. It may be the
RHEL6 is one of those bits of "troublesome code" which doesn't
consistently use fsync properly. I don't mean that to be
overly-provocative. And I should check further. But so far I'm not
seeing a lot of evidence of fsyncs being used consistently on
significant config files. It may or may not be an area where there is
room for improvement in the excellent RHEL6 product. :-)

-Steve
