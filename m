From: "Nicholas Ipsen(Sephiroth_VII)" <sephiroth7vii@gmail.com>
Subject: Trouble adding disk to degraded array
Date: Wed, 9 Jan 2013 18:21:29 +0100
Message-ID: <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com>
References: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I recently had mdadm mark a disk in my RAID5-array as faulty. As it
was within warranty, I returned it to the manufacturer, and have now
installed a new drive. However, when I try to add it, recovery fails
about halfway through,  with the newly added drive being marked as a
spare, and one of my other drives marked as faulty!

I seem to have full access to my data when assembling the array
without the new disk using --force, and e2fsck reports no problems
with the filesystem.

What is happening here?
