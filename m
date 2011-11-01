From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 09:05:25 -0400
Message-ID: <4EAFEE95.6070608@meetinghouse.net>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j8odkj$46h$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown wrote:
>
> One thing to watch out for when making high-availability systems and 
> using RAID1 (or RAID10), is that RAID1 only tolerates a single failure 
> in the worst case.  If you have built your disk image spread across 
> different machines with two-copy RAID1, and a server goes down, then 
> the rest then becomes vulnerable to a single disk failure (or a single 
> unrecoverable read error).
>
> It's a different matter if you are building a 4-way mirror from the 
> four servers, of course.
>

Just a nit here: I'm looking at "md RAID10" which behaves quite 
differently that conventional RAID10.  Rather than striping and raiding 
as separate operations, it does both as a unitary operation - 
essentially spreading n copies of each block across m disks.  Rather 
clever that way.

Hence my thought about a 16-disk md RAID10 array - which offers lots of 
redundancy.

Miles

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


