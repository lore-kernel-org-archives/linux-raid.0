From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/1] RFC: Unreliable discard performance can cripple RAID1
Date: Wed, 24 Jun 2015 21:05:07 -0400
Message-ID: <yq1k2us38e4.fsf@sermon.lab.mkp.net>
References: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
	<20150624175556.701b724c@noble> <wrfj616dtlmb.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj616dtlmb.fsf@redhat.com> (Jes Sorensen's message of "Wed, 24
	Jun 2015 07:02:36 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Jes" == Jes Sorensen <Jes.Sorensen@redhat.com> writes:

>> Or is this some non-SATA/SCSI SSD that has a 'make_request_fn'
>> driver?  I think I came across one of those before (NVMe).  In that
>> case - the driver needs to be fixed.

Jes> Nope the block layer doesn't merge the requests at this point.

Then something broke it. Discard merging used to work.

-- 
Martin K. Petersen	Oracle Linux Engineering
