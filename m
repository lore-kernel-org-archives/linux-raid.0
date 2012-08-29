From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 0/7 v2] MD linear/0/1/10/5 TRIM support
Date: Wed, 29 Aug 2012 16:19:30 -0400
Message-ID: <yq1wr0hpi25.fsf@sermon.lab.mkp.net>
References: <20120810025113.050392766@kernel.org>
	<alpine.LRH.2.02.1208291828040.22763@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1208291828040.22763@diagnostix.dwd.de> (Holger
	Kiehl's message of "Wed, 29 Aug 2012 18:58:09 +0000 (GMT)")
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Shaohua Li <shli@fusionio.com>, linux-raid <linux-raid@vger.kernel.org>, neilb@suse.de, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

>>>>> "Holger" == Holger Kiehl <Holger.Kiehl@dwd.de> writes:

>> Previously when I posted the patches out, people complain SATA SSD
>> discard request merge error. Now a patch to disable discard request
>> merge is in Jens's tree. We don't have this issue any more.

And fwiw I have been working on discard/write same merging the last
couple of days. Almost there...

-- 
Martin K. Petersen	Oracle Linux Engineering
