From: Aaron Lehmann <aaronl@vitelus.com>
Subject: Benchmarks comparing 3ware 7410 RAID5 to Linux md
Date: Mon, 8 Sep 2003 15:58:52 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030908225852.GN2743@vitelus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm about to set up an IDE RAID5 with 4 7200rpm 160GB hard drives
under Linux 2.6.0-test. I found a 3ware Escalade 7410 card and thought
this would be perfect for the job, but read recently about the poor
write performance. It was suggested in the archives that Linux
software raid could do better. While reliability and read performance
are my main concerns, in that order, I wouldn't mind having decent
write performance too. Since I haven't seen any benchmarks comparing
Linux software raid with 3ware hardware raid, I think it would be
interesting to do some myself, especially because a 3ware controller
running in JBOD mode should be significantly better than most other
IDE controllers. I plan to use tiobench and bonnie as suggested in the
FAQ, but I'd welcome suggestions for other benchmarks to run.

I have some questions about setting up this test and practical use of
software raid:

* Can software raid 5 reliably deal with drive failures? If not, I
don't think I'll even run the test. I've heard about some bad
experiences with software raid, but I don't want to dismiss the option
because of hearsay.

* Is it possible to boot off a software array with LILO or GRUB?

* This is probably a major point of contention, but what filesystem(s)
fit well with my priorities of reliability, then read speed, then
write speed? I only need metadata journalling. XFS and ext3 are the
two fs' that come to mind, but I'm not sure how they compare, and
again, I haven't seen great benchmarks.

* Is it a good idea to tell ext3 about the stride of the array even
on a hardware RAID setup? If I go the XFS route, is there any
equivalent?

* Any particular /proc settings that could be tweaked? I've seen
suggestions relating to bdflush, but don't know if they still apply
to 2.6.

I'd also like to note that even if I don't end up using software raid,
it seems like a great subsystem and I'm thankful for its development.

Thanks,
Aaron Lehmann
