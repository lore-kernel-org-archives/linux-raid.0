From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Problem with DISCARD and RAID10
Date: Tue, 06 Nov 2012 17:39:55 -0500
Message-ID: <yq1pq3q4apw.fsf@sermon.lab.mkp.net>
References: <5098D92A.3000503@fnarfbargle.com>
	<20121106114017.GB19182@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121106114017.GB19182@kernel.org> (Shaohua Li's message of
	"Tue, 6 Nov 2012 19:40:17 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Brad Campbell <brad@fnarfbargle.com>, linux RAID <linux-raid@vger.kernel.org>, martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com
List-Id: linux-raid.ids

>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:

Shaohua> cc Martin to check if he has idea.

Shaohua> Hmm, I thought such problem is already fixed by Martin's
Shaohua> discard merge patches and my last test in SATA SSD doesn't show
Shaohua> this problem. 

Discard is broken in 3.7 because the relevant block layer patches went
in but James didn't queue the matching SCSI changes.

-- 
Martin K. Petersen	Oracle Linux Engineering
