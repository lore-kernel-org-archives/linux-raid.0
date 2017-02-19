From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID10 and 'writemostly' support
Date: Sun, 19 Feb 2017 12:31:06 -0500
Message-ID: <08f52436-9de4-76d0-99c0-c90dedee8ae1@turmel.org>
References: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
 <033aa14d-32a0-531d-7d7d-c01a0aeb13eb@youngman.org.uk>
 <f6ed7560-97b8-78ef-26be-789a8bc372b5@thelounge.net>
 <7090c5c7-7f02-14a3-36f1-23b8bfe53043@turmel.org>
 <5a11be45-1793-d4b7-7cf5-3adaef5740d6@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a11be45-1793-d4b7-7cf5-3adaef5740d6@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/18/2017 06:35 PM, Reindl Harald wrote:
> 
> Am 18.02.2017 um 23:20 schrieb Phil Turmel:

>> If there are features (other than layouts) of raid10 that make you
>> prefer it to raid1, it would make sense to ask for those features to
>> be implemented in raid1.
> 
> writemostly it's also very appealing on existing setups, the machine
> from where i type was installed in 2011
> 
> RAID1 don't have the benefit of doubled performance (also for writes, on
> a hybrid RAID slower but still faster than RAID1) *and* doubled space
> compared to a single disk combined with mirroring

Doubled capacity?  Vs. raid1?  No.  Raid10,n2 (,n2 is default) on two
devices yields the same capacity as raid1 on two devices.  Unless I'm
misunderstanding your point.

> another example: on machines like a HP microserver with only 4 drive
> slots that you could easily improve read-performance which is for many
> workloads the most important part by just switch half of the disk to SSD
> 
> price calculation for a hybrid RAID10 with 10 disks:
> 5x4 TB SSD = 5 x 1400€ = 7000€
> 5x4 TB HDD = 5 x 100€ = 500€
> total price 7500€ versus 14000€ for flash-only

What is preventing you from using the existing raid1 in pairs with
write mostly, then layering raid0 on top of them for the capacity you
are trying to achieve?  No new code required.  What you are asking for
really is raid1+0, which MD raid allows you to assemble yourself.

> i would be *seriously* willing to pay the inital patch for any kernel
> maintainer who takes it over - Fedora regulary does kernel-rebases on GA
> versions

Since no new kernel code is needed to achieve what you desire, I doubt
a kernel patch for it would be accepted. (But I'm not a maintainer, so
YMMV.)  This is really a user-space question, along the lines of
"should/could mdadm automate creation of dual layers like raid1+0?"

Phil

