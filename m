From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 9 Jun 2013 18:34:13 -0500
Message-ID: <CAO9HMNGwdLG7ubNP1gC7To9pNstuwZPDAeV03HDkUjh5MWB0Dg@mail.gmail.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
	<51B47088.4000501@redhat.com>
	<CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
	<loom.20130610T000503-316@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130610T000503-316@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Eric,

Yes, I understand what you are saying about the interaction between
ordered data mode and DA in ext4. It's the combination of the 2
options that makes the difference. Merely having a switch to turn off
DA on XFS would not get me what I need for my data volumes. But thank
you for making that explicit.

I intentionally disable DA on my ext4 data volumes specifically to get
ext3-like behavior which results in a night and day difference in
resiliency during... difficult times... for many of my customers, in
my repeated experiences. I could just use ext3. But why give up
extents, multiblock allocation, CRC protection of the journal, etc?
(BTW, that's my vote *not* to remove the nodelalloc option of ext4 as
I noticed you and Ted discussing last April. ;-)

So on a set of Cobol C/ISAM files which never get fsync'd or
fdatasync'd, (because that concept does not exist in Cobol) would you
expect there to be any difference in the resiliency of ext4 and xfs
with both filesystems at completely default settings? Or would it be
about the same. I'm *very* interested in this topic, as I'd like the
best speed and more filesystem options, but need the resiliency even
more for many of my servers. Do I have an option with XFS to improve
behavior on/after an unclean shutdown? If so, I'd sincerely like to
know.

XFS is an excellent filesystem. Indispensable for certain use-cases.
If you need > 16TB files, there's nothing like it. (And I'm sure there
are other good use-cases.) Similarly, DA is a valuable filesystem
feature. And I'm very glad that both XFS & Ext4 have it available to
me. But as with any filesystem or fs feature, there are always
trade-offs, risks and benefits, etc. And those differences have turned
out to be crucially important to me and to quite a number of my
customers.

-Steve
