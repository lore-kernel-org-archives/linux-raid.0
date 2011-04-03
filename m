From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: Raid Checks
Date: Sun, 03 Apr 2011 12:30:03 +0100
Message-ID: <4D985A3B.8030801@abpni.co.uk>
References: <4D983064.30808@abpni.co.uk>	<4D98346F.8090502@abpni.co.uk>	<20110403210157.2c3ac83d@notabene.brown>	<4D98544E.9000107@abpni.co.uk> <20110403211937.0a6efdee@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110403211937.0a6efdee@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>>          This is what state my server is currently in:
>>
>> State : clean, resyncing
> With mdadm 3.2.1, this will show "checking" when it is checking, rather than
> "resyncing".
Interesting. So during a normal "resync", I'm guessing redundancy will 
be lost? Also, if the "checking" process finds an error, where will I 
find it? /var/log/messages?

Thanks
