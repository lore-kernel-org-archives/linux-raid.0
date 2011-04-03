From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid Checks
Date: Sun, 03 Apr 2011 13:18:52 +0100
Message-ID: <4D9865AC.6060607@anonymous.org.uk>
References: <4D983064.30808@abpni.co.uk>	<4D98346F.8090502@abpni.co.uk>	<20110403210157.2c3ac83d@notabene.brown>	<4D98544E.9000107@abpni.co.uk> <20110403211937.0a6efdee@notabene.brown> <4D985A3B.8030801@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D985A3B.8030801@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/04/2011 12:30, Jonathan Tripathy wrote:
>>> This is what state my server is currently in:
>>>
>>> State : clean, resyncing
>> With mdadm 3.2.1, this will show "checking" when it is checking,
>> rather than "resyncing".
> Interesting. So during a normal "resync", I'm guessing redundancy will
> be lost?

You only need a resync when you've already lost redundancy. The only 
normal resync is at array creation time, when mdadm will instantly 
create the array with no redundancy and then proceed to generate the 
mirror/parity information. Any other resync is only required after 
something else caused a loss of redundancy e.g. a disc dying or a system 
crash, or perhaps a drive threw up a bad sector. The check process will 
attempt to discover any such problems.

As Doug Ledford noted in the Red Hat Bugzilla there are times when a md 
RAID 1 can harmlessly end up out of sync.

> Also, if the "checking" process finds an error, where will I
> find it? /var/log/messages?

In the email the raid-check process sends you. Any errors found are not 
reported in detail on RHEL/CentOS 5 - I think more recent kernel/mdadm 
can be asked to be more verbose about the location of errors. Requesting 
a repair rather than a check would get the check process to 
automatically resync any stripes which had bad mirrors/parity.

In short, it is safe to ignore a modest mismatch_cnt on RAID 1 as long 
as you aren't seeing disc errors, and that is what Doug Ledford's patch 
to raid-check does.

Cheers,

John.

