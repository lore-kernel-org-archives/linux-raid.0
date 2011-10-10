From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: md RAID10 questions
Date: Mon, 10 Oct 2011 17:37:03 -0400
Message-ID: <4E93657F.1090500@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Folks,

As far as I can tell, md RAID10 is the greatest thing since sliced bread 
- mirroring and striping in one operation (more efficient disk use, 
better performance), avoids the RAID5/6 write hole issue, etc. - I've 
been having very good luck with it on two servers that I run.

The thing is, I'm looking at some scaling and clustering options, and 
can find practically no documentation or case studies or much of any 
information about md RAID10 - which sort of surprises me.  I'd think it 
would be more popular and there'd be more comparisons vis-a-vis other 
options.

Anyway... what I'm looking at is trying to create a large storage pool, 
out of 16 drives, spread across 4 servers - essentially trying to create 
a poor man's storage cloud to support a collection of VMs that can be 
migrated for load leveling and failover.

One thought is to expose all the drives via AoE, then combine them into 
one large RAID10 array - but I'm neither sure this is feasible nor how 
it would perform under various loads, failure conditions, etc.

Thoughts, pointers, ....?

Thanks,

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


