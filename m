From: Jaromir Capik <jcapik@redhat.com>
Subject: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Wed, 18 Jul 2012 07:01:48 -0400 (EDT)
Message-ID: <a62c8158-aae7-4924-8408-e0302ff4e9b3@zmail15.collab.prod.int.phx2.redhat.com>
References: <17025a94-1999-4619-b23d-7460946c2f85@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17025a94-1999-4619-b23d-7460946c2f85@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I'd like to ask you to implement the following ...

The current RAID1 solution is not robust enough to protect the data
against random data corruptions. Such corruptions usually happen
when an unreadable sector is found by the drive's electronics
and when the drive's trying to reallocate the sector to the spare area.
There's no guarantee that the reallocated data will always match
the original stored data since the drive sometimes can't read the data
correctly even with several retries. That unfortunately completely masks
the issue, because the sector can be read by the OS without problems
even if it doesn't contain correct data. Would it be possible
to implement chunk checksums to avoid such data corruptions?
If a corrupted chunk is encountered, it would be taken from the second
drive and immediately synced back. This would have a small performance
and capacity impact (1 sector per chunk to minimize performance impact
caused by unaligned granularity = 0.78% of the capacity with 64k chunks).

Please, let me know if you find my request reasonable or not.

Thanks in advance.

Regards,
Jaromir.

--
Jaromir Capik
Red Hat Czech, s.r.o.
Software Engineer / BaseOS

Email: jcapik@redhat.com
Web: www.cz.redhat.com
Red Hat Czech s.r.o., Purkynova 99/71, 612 45, Brno, Czech Republic
IC: 27690016 


