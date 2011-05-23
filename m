From: Jim Schatzman <James.Schatzman@fulab.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 20:11:54 -0600
Message-ID: <20110523021234.1BAEAF9C03C@mail.fulab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

One more input re. using cheap drives. 

I have been running about 20 Western Digital "Green" and "Enterprise" drives (half are 1.5 TB and half are 2 TB) for several years in Raid-5 and Raid-6 configurations (all linux md). They are up 24x7. When they first came on the market, about 30% of my new drives failed within 3 months of operation (about equal fractions of Green and Enterprise). Overall, 50% of the drives eventually failed - 35% of the Green drives and 100% of the Enterprise drives. In the past 18 months, one has failed (an Enterprise drive). That drive was a warranty replacement for an earlier Enterprise drive failure.

My impression is that Western was having some quality control issues with the 2GB drives - both Green and Enterprise. This was very annoying. It appears that quality has improved. I never lost any data nor ever had to restore from backup because I was always able to replace the bad drive and rebuild the raid without difficulty that I could not get solved through this forum. 

My experience suggests that the WD Enterprise class drives were an unnecessary expense, at least as far as reliability is concerned.

Would I recommend cheap SATA drives for mission critical data?  Absolutely not. I wouldn't recommend  any  SATA drives. Go with the most  expensive SAS drives available. For that matter, I have loads of SCSI drives that are still going fine after 5 to 10 years of 365x24x7 operation.

If you are going to build a RAID from cheap drives, expect that part of your hardware savings will be compensated for by labor costs. Run smart checks often. Also, and I cannot emphasize this enough, make certain that everything attached to the RAID is plugged into a high quality UPS. Otherwise, you are just asking for a power spike to take out multiple drives and/or the controller and to lose data.

Jim

