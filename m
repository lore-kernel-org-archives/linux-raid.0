From: Lapohos Tibor <tibor.lapohos@rogers.com>
Subject: Re: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Thu, 7 Jan 2010 06:59:23 -0800 (PST)
Message-ID: <812101.52805.qm@web88205.mail.re2.yahoo.com>
References: <1894585.O4pOeKWFqe@rnqqfki.eternal-september.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1894585.O4pOeKWFqe@rnqqfki.eternal-september.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for all your help again.

Things worked out nicely, and they left me wondering about what had really happened.

Trial #1:
I wiped out the disks, repartitioned them using fdisk starting the first partition at the 2nd cylinder to obtain sd[ab][12], and made md0 = sd[ab]1 and md1 = sd[ab]2. Installed GRUB2 without a problem.

Trial #2:
Then I repeated this very same thing, only this time I further partitioned the md[01] drives. The GRUB installation worked, again. The only problem was that before needing the root partition to become available the kernel would not detect the RAID partititons, only the arrays. So md0p1 was not available to be mounted, and this way I would need an initrd in the process.

Trial #3!!
I repeated Trial #1, by starting the firsst partition at the first cylinder. It worked! Therefore, I'm suspecting that cfdisk could have been the culprit the first time. How, I don't know.

Thanks again for all the attention you gave me,
Tibor

