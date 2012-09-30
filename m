From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Sun, 30 Sep 2012 13:50:02 -0600
Message-ID: <935F0E03-C6D9-4FC2-BCDB-9ACADDC01173@colorremedies.com>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se> <50689B6C.8000307@ejane.org>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50689B6C.8000307@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 30, 2012, at 1:20 PM, EJ Vincent wrote:

> On 9/30/2012 6:04 AM, Mikael Abrahamsson wrote:
>> 
>> <http://neil.brown.name/blog/20120615073245>

> 3.2.0-23-generic.

That kernel is inside the range that had the bug, although I'm not sure if that kernel actually has the bug. The symptoms match up as you say.

> 
> That link looks interesting-- I'm not sure if I triggered the bug how Mr. Neil Brown describes it, but I definitely have symptoms on some (not all) the disks of RAID level "-unknown-" and devices appearing to be spares.
> 
> I'm hesitant to re-create the array again (using mdadm) because according to that blog post, for RAID-6, the order of devices are important, and with this being a 9 disk array and no record of device order in logs or from my own memory, I have no idea what the proper order might be.

You'll have to iterate, it sounds like, if you have nothing else to go on. Faster to iterate and try again than to blow way the RAID and restore from backup.

> I do know that 1) I was using metadata version 1.2, 2) the array was not degraded and subsequently 3) no disks were missing.
> 
> Am I over-estimating the importance of the order and should proceed with the re-creation, or perhaps wait for Neil himself to weigh in the problem?

Either. Just make sure you're using --assume-clean and don't mount it, to prevent either resync or changes to the file system. The echo > check (read only scrub) test described in the blog entry will rather clearly tell you if you get the order of the disks correct. The blog entry is pretty detailed. The question I have remaining is if there's some way for you to cheat and have a better chance at getting the disk order correct.

Chris Murphy