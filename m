From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 20:52:54 -0500
Message-ID: <20091025015257748.WYGS6016@cdptpa-omta03.mail.rr.com>
References: <7bc80d500910240759x443e7a00n4fdcb41f60ec9d73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7bc80d500910240759x443e7a00n4fdcb41f60ec9d73@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm going to go on a limb here and say for anyone (with data they want
> to preserve), no matter what, backups make sense and are cost
> effective. I'm going to be crazy and say that there's no reason that
> someone who thinks they can afford a 8TB disk array and dual SLI video
> cards, etc, etc, can't also consider some sort of disk or tape backup.

	I agree with the disk backup, but not the tape.

> Cumbersome? Can be. But having worked with datasets and filesystems

	Cumberesome, slow, kludgy, and expensive.

> that run into the hundreds of terabytes, and having backed them up to
> tape, it makes sense. If you have something on the order of tens of
> disks, sure, go ahead, take that next step and back them up somewhere
> else to another set of disks. If you have more disks, seriously
> consider tape--in terms of capacity and power consumption (and data
> integrity), tape wins.

	Power consumption, yes.  Capacity is a somewhat more complex
problem, with a number of variables.  For speed, tapes lose disastrously.
For cost, hard drives win unless the array is very large.  For reliability
and availability, drives win hands down.  I've had quite a bit of data lost
with bad tape sets, and the most persistent problems on my systems which do
use tapes involve the tape drives, even sans data loss.  Once someone wiped
out a directory which someone up in corporate was backing up to tape.  It
took 3 days to recover the directory, no doubt because no one could find the
tape.


