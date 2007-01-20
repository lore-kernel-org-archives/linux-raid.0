From: "Roger Lucas" <roger@planbit.co.uk>
Subject: RE: bad performance on RAID 5
Date: Sat, 20 Jan 2007 10:18:28 -0000
Message-ID: <000901c73c7c$5404cb00$8001a8c0@wolverine>
References: <45AE9640.1040500@start.no> <Pine.LNX.4.64.0701181731080.3052@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701181731080.3052@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Sevrin Robstad' <quackyo@start.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Sevrin,

Are you sure all the disks are working OK?

We saw a problem here with a 4-disk SATA array.  The array was working
without errors but was _very_ slow.  When we checked each disk individually,
we found one disk was reporting SMART errors and running slow.  We removed
it and replaced it with a new disk and the RAID array ran at full speed
again.  Further tests on the removed disk found that it was having a lot of
problems but just about hanging in there (although taking a long time for
each operation) - hence the RAID array didn't mark it as faulty.

I would check the SMART logs with smartctl to see if anything looks a bit
wrong and try benchmarking the disks individually too.

- Roger

