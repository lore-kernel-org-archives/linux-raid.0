From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Fri, 24 Jan 2014 09:11:34 -0700
Message-ID: <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E2691E.4050701@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 24, 2014, at 6:22 AM, Phil Turmel <philip@turmel.org> wrote:
> 
> No, they aren't improbable.  That's my point.  For consumer drives, you
> can expect a new URE every 12T or so read, on average.

- Define URE.

Western Digital, HGST, and Seagate don't use the term URE/unrecoverable read error. They use, respectively:

non-recoverable read error per bits read
error rate, non-recoverable, per bits read
nonrecoverable Read Errors per Bits Read, Max

These are all identical terms?

- How does the URE manifest? That is, does the drive always report a read error such as this?

ata3.00: cmd c8/00:08:55:e8:8d/00:00:00:00:00/e2 tag 0 dma 4096 in
es 51/40:00:56:e8:8d/00:00:00:00:00/02 Emask 0x9 (media error)
ata3.00: status: { DRDY ERR }
ata3.00: error: { UNC }

Or does URE include silent data corruption, and disk failure?

- How many bits of loss occur with one URE?



> 
> Your comments suggest you've completely discounted the fact that
> published URE rates are now close to, or within, drive capacities.
> 
> Spend some time with the math and you will be very concerned.

Yeah I tried that a year ago and when it came to really super basic questions, no one was willing to answer them and the thread died as if we don't actually know what we're talking about. So I think some rather basic definitions are in order and an agreement that we don't get to redefine mathematics by saying a max error rate is a mean.

http://www.spinics.net/lists/raid/msg41669.html




Chris Murphy

