From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Fri, 17 Feb 2012 16:12:34 -0600
Message-ID: <4F3ED0D2.2000002@hardwarefreak.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com> <20120215083058.GA8821@cthulhu.home.robinhill.me.uk> <4F3BB385.4000608@hardwarefreak.com> <4F3BD1F6.8080309@westcontrol.com> <4F3E5325.3060001@hardwarefreak.com> <20286.42115.949782.471398@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20286.42115.949782.471398@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/17/2012 1:03 PM, Peter Grandi wrote:

> As I have repeated many many many times to you in past XFS
> discussions, and please take note, stripe alignment matters ONLY
> AND SOLELY IF READ-MODIFY-WRITE is involved, and RADI10 never
> requires read-modify-write.

A wise Jedi once contradicted himself when he advised me to "never speak
in absolute terms".  A wiser Jedi would have said "don't speak in
absolute terms".

[...]
> Disclaimer: using stripe alignment even when it is not required
> may help a bit with scheduling, it being slightly akin to a
> larger block size, but not quite, but that is a secondary
> effect.

And the inevitable future contradiction is the reason.  The wisest of
Jedi once told me "do not leave performance on the table".  Whether you
consider this "scheduling" effect, or others, of write alignment on non
RMW devices to be secondary, it does have positive performance
implications, and should thus not be left on the table.

More importantly, and I could be mistaken, but IIRC, even absent an
underlying RMW block device, XFS journal writes benefit from alignment
due to a resulting lower ratio of write barriers issued to blocks
written, due to the larger stripe width write out.  And as we all know
(or should), write barriers can murder performance, especially for
metadata heavy workloads, as each barrier operation typically flushes
all the drives' caches.  Most mdraid users probably don't run BBWC RAID
cards in JBOD mode to avoid barriers, though I know of a few who do.  So
XFS write alignment on mdraid should be an issue for most everyone using
XFS, regardless of whether their array is parity RMW or not.

Both unaligned RMW and write barriers are performance killers.  Which
one has more blood on its hands I can't say.  I've never done such
testing nor come across a related paper.

-- 
Stan
