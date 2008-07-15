From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 19:39:27 +0200
Message-ID: <20080715173927.GA24745@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: monkeyiq@users.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 15, 2008 at 12:50:57PM -0400, thomas62186218@aol.com wrote:
> Hi Ben,
> 
> Nice reporting on the benchmarks. It would be helpful though to run 
> these tests without a file system involved, using a block level 
> benchmark utility like fio or similar to really measure the RAID 
> performance in isolation. While you did use a file system in both your 
> hardware and software RAID tests, before directly implicating software 
> RAID, it makes sense to isolate it as much as possible in the testing 
> by eliminating the file system for benchmarks.

I think actually the use of the file systems is one of the strengths of
this report. Many benchmarks are done only on the raw raid systems, and
that gives some aritficial benchmarks that are only of theoretical
interest, as the user really needs to have a FS  to employ the raids.
And the file system layer can compensate a lot for some characteristics
of the raid types. 

I would actually welcome more tests with specific user profiles, like
many small reads and writes for database  use, and concurrent random
reading and writing to simulate the load on a server. What bonnie++ is
reporting is only equential IO. This is important on work stations, but
actually not on servers.

I have a new category - namely sequential reads on a system already
running a workload of mostly random reading, but also some writing. 
this is important on some of my servers, like a ftp server.
How fast can a new user get a file on an already loaded server?
I dont know how to measure it in a reproducable way, but I do have some 
experimential figures.

Best regards
Keld
