From: <me@heyjay.com>
Subject: Re: Sync rates?
Date: Thu, 6 May 2004 14:48:28 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00c501c433a3$2822c670$6705a8c0@a30>
References: <00a401c4339e$7f86b340$6705a8c0@a30> <yw1xsmede4hk.fsf@kth.se>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
List-Id: linux-raid.ids

>> Hi,
>>
>> I added a 120GB drive to a degraded raid 1 drive (well it's really 5
>> partitions all raid 1).  I started last night (maybe 8pm) at this rate it
>> will be done syncing in just under 24 hours.  Is this sync rate expected?
I
>> would have thought 120GB wouldn't have taken that long, I'm running
7200RPM
>> IDE drives on separate controllers, with an Athlon 3200.

>My raid1 over two 240GB raid0 arrays sync in about 3 hours.  Maybe you
>are syncing all 5 partitions at the same time.  That would be likely
>to cause a slowdown since the disk would be seeking quite a bit.

Indeed I did sync them all at the same time.  But when I cat /proc/mdstat
four partitions were delaying syncing while on performed a sync

Jay


