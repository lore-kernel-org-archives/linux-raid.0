From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: Benchmarks comparing 3ware 7410 RAID5 to Linux md
Date: Mon, 8 Sep 2003 18:37:03 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0309081825330.19837-100000@multivac.sdsc.edu>
References: <20030908225852.GN2743@vitelus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030908225852.GN2743@vitelus.com>
To: Aaron Lehmann <aaronl@vitelus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Aaron,

> I'm about to set up an IDE RAID5 with 4 7200rpm 160GB hard drives
> under Linux 2.6.0-test. I found a 3ware Escalade 7410 card and thought
> this would be perfect for the job, but read recently about the poor
> write performance. It was suggested in the archives that Linux
> software raid could do better. While reliability and read performance
> are my main concerns, in that order, I wouldn't mind having decent
> write performance too. Since I haven't seen any benchmarks comparing
> Linux software raid with 3ware hardware raid, I think it would be
> interesting to do some myself, especially because a 3ware controller
> running in JBOD mode should be significantly better than most other
> IDE controllers. I plan to use tiobench and bonnie as suggested in the
> FAQ, but I'd welcome suggestions for other benchmarks to run.

Look at using IOMETER.  This will give you information on the I/O
Transaction abilities of the configuration.

> I have some questions about setting up this test and practical use of
> software raid:
>
> * Can software raid 5 reliably deal with drive failures? If not, I
> don't think I'll even run the test. I've heard about some bad
> experiences with software raid, but I don't want to dismiss the option
> because of hearsay.

Both hardware (3Ware 7410) and software RAID-5 will deal with a drive
failure.  The important difference is that the hardware RAID does so with
no CPU overhead.  There will be a significant performance drop (reading or
writting) with both.  Another difference is that hardware RAID-5 allows
hot-swap of the drives.

> * Is it a good idea to tell ext3 about the stride of the array even
> on a hardware RAID setup?

If shouldn't hurt, and might actually help.  I've never seen a benchmark
on this.

> * Any particular /proc settings that could be tweaked? I've seen
> suggestions relating to bdflush, but don't know if they still apply
> to 2.6.

The following are suggested by 3Ware:

	vm.max-readahead = 256
	vm.min-readahead = 128

Good luck.
				Peter Ashford

