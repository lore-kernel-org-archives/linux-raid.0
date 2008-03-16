From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Useful benchmarking tools for RAID
Date: Sun, 16 Mar 2008 23:39:32 +0000
Message-ID: <18397.44980.946243.573835@tree.ty.sabi.co.uk>
References: <1205360878.30451.134.camel@atlantis.cc.ndsu.nodak.edu>
	<18393.37268.150207.688089@tree.ty.sabi.co.uk>
	<1205449115.30451.214.camel@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1205449115.30451.214.camel@atlantis.cc.ndsu.nodak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Thu, 13 Mar 2008 17:58:35 -0500, Bryan Mark Mesich
>>> <bmesich@atlantis.cc.ndsu.nodak.edu> said:

[ ... performance boost for an IMAP mail server ... ]

bmesich> We are currently using mbx mail format, but are looking
bmesich> into switching to mixed (not sure if 'mixed' is the
bmesich> correct terminology). We were hoping that the smaller
bmesich> file sizes would in turn cause more efficient I/O. Any
bmesich> thoughts on this change?

Smaller file sizes usually don't cause more efficient IO, but
may cause more effective IO. But one negative aspect of small
files is more metadata access, and many file systems don't
handle metadata well (as to that, investigate using "nodiratime"
and either "noatime" or "relatime" already).

It depends on how your users interact with the mail store and
the current distribution of mail store file sizes. For example
if most of your users keep their mail (as you indicate below)
and keep it as many do in a single Inbox of up to 500MB, just
about any operation (except delivery) will rewrite it, and in
your current setup rewrite performance is terrible at around
20MB/s.

However, if you move to smaller files ReiserFS seems better, if
you keep mbox JFS is nicer, and if the mboxes are largish
perhaps XFS is better.

bmesich> In our setup, the mail servers store the mail
bmesich> permanently (unless users delete). Users have a 512MB
bmesich> quota on their mailboxes.

It would be interesting to have look whether they then split
their mailboxes into folders or keep it all in the Inbox. In
other words to have a look at the number and size of files.

bmesich> mirrored SAN volumes via Dual 4GB fibre channel HBA's.
bmesich> Typical volume size for the mail to sit on is around
bmesich> 250GB. The fibre targets are running RAID5 in a 3+1
bmesich> layout in separate geographic areas (my test box is a
bmesich> fibre target replacement not yet in service, thus the
bmesich> small amount of memory). I should also mention that we
bmesich> are using bitmaps on the RAID1 array.  Possibly moving
bmesich> these to local disk would increase performance some?

bmesich> Some of my readings indicated that larger chunk sizes
bmesich> can increase I/O performance where random writes/reads
bmesich> occur often. [ ... ]

Yes, but that also increases RAID5 stripe size, making the
chances of avoiding RMW lower.

bmesich> [ ... ] disabling write-chaching on the controller
bmesich> might effect the cache on the drives themselves.

Well, that depends on the firmware of the host adapter. Somewhat
reasonably if you tell it that its own cache can't be used, some
will assume that enabling the disk cache isn't safe either.

bmesich> As for battery backup, the whole data center is
bmesich> protected by a UPS.  I was referring to controller
bmesich> batteries on the 3ware cards.

But if the whole data center is on UPS, the battery on the
individual host adapter is almost redundant (I can imagine some
cases where power is lost to a single machine of course).

bmesich> I was under the assumption that batteries on the
bmesich> controllers are a must when using write-caching
bmesich> sensibly.

Well, yes and no. In general the Linux cache is enough for
caching and the disk cache is enough for buffering.

The host adapter cache is most useful for RAID5, as a stripe
buffer: to keep in memory writes that do not cover a full stripe
hoping that sooner or later the rest of the stripe will be
written and thus a RMW cycle will be avoided. In your case
that may be a vain hope.

bmesich> [ ... ] average I/O request size to be around 440k/sec.
bmesich> So, with a 128MB of cache ([128*1024]/440)/60 = 4.9
bmesich> minutes of cache time before it is over-writen?

Here the calculation seems motivated by thinking of the host
adapter cache as a proper cache for popular blocks. But in your
case I suspect that is not that relevant.

[ ... ]

bmesich> Is JFS being supported my IBM anymore?

It was never supported by IBM... The only filesystem for which
you can get support (with a modest fee) is ReiserFS, and 'ext3'
for RedHat customers only.

However IBM have stopped actively developing JFS, much as SGI
have stopped actively developing XFS, and RedHat have stopped
actively developing 'ext3'.

The main difference is in reactiveness to bug fixing: for JFS
it is up to the general kernel development community, while for
ReiserFS, XFS and 'ext3' there is a sponsor who cares (somewhat)
about that.

>> Note a little but important point of terminology: a mail server
>> and a mail store server are two very different things. They may
>> be running on the same hardware, but that's all.

bmesich> Thanks for the correction :)

Well, it was not a correction, but a prompt to consider the
impact of mail delivery. You have been trying to simplify the
description of your situation, but an IMAP mail store is fed
from a mail spool, and the mail spool from some network link.

A large impact on the performance of your mail store may be how
mail is delivered into it, and whether the mail transport server
and the mail delivery system are running on the same servers as
the mail store.

For example, if the mail store and the mail spool are on the
same server or disks then the one network interface is busy with
3 types of traffic:

* incoming e-mail
* outgoing e-mail
* outgoing mail store data

and mail delivery is likely to be local.

There is also incoming mail store requests, but they are likely
to be trivial (if numerous).

bmesich> We are currently running 7 imap servers servicing
bmesich> around 15,000+ users. [ ... ]
bmesich> The most damaging user actions seem to be internal
bmesich> listserv messages marked for thousands of users. [
bmesich> ... ]

In that case mail spooling and delivery are likely to be a very
big part of the equation.

You may want to investigate IMAP servers that store mailboxes
using DBMSes, they often store each message and attachment once
no matter how many local recipients it has.

Overall I suspect that your RAID issues are small compared to
the rest, even if the rather low RAID5 write rates reported
surely contribute robustly, suggesting that taking care about
alignment (at least) would help. But RAID10 does not have
special writing issues.
