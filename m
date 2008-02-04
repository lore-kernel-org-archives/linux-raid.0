From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 20:22:17 +0300
Message-ID: <47A749C9.6010503@msgid.tls.msk.ru>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A72FBC.9090701@pobox.com> <47A7411F.2040702@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A7411F.2040702@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Moshe Yudkowsky <moshe@pobox.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Eric Sandeen wrote:
> Moshe Yudkowsky wrote:
>> So if I understand you correctly, you're stating that current the most 
>> reliable fs in its default configuration, in terms of protection against 
>> power-loss scenarios, is XFS?
> 
> I wouldn't go that far without some real-world poweroff testing, because
> various fs's are probably more or less tolerant of a write-cache
> evaporation.  I suppose it'd depend on the size of the write cache as well.

I know no filesystem which is, as you say, tolerant to a write-cache
evaporation.  If a drive says the data is written but in fact it's
not, it's a Bad Drive (tm) and it should be thrown away immediately.
Fortunately, almost all modern disk drives don't lie this way.  The
only thing needed for the filesystem is to tell the drive to flush
it's cache at the appropriate time, and actually wait for the flush
to complete.  Barriers (mentioned in this thread) is just another
way to do so, in a somewhat more efficient way, but normal cache
flush will do as well.  IFF the write caching is enabled in the
first place - note that with some workloads, write caching in
the drive actually makes write speed worse, not better - namely,
in case of massive writes.

Speaking of XFS (and with ext3fs with write barriers enabled) -
I'm confused here as well, and answers to my questions didn't
help either.  As far as I understand, XFS only use barriers,
not regular cache flushes, hence without write barrier support
(which is not here for linux software raid, which is explained
elsewhere) it's unsafe, -- probably the same applies to ext3
with barrier support enabled.  But I'm not sure I got it all
correctly.

/mjt
