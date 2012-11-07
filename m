From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Problem with DISCARD and RAID10
Date: Wed, 07 Nov 2012 10:39:43 -0500
Message-ID: <yq1obj92zi8.fsf@sermon.lab.mkp.net>
References: <5098D92A.3000503@fnarfbargle.com>
	<20121106114017.GB19182@kernel.org>
	<yq1pq3q4apw.fsf@sermon.lab.mkp.net>
	<5099DA33.8050406@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5099DA33.8050406@fnarfbargle.com> (Brad Campbell's message of
	"Wed, 07 Nov 2012 11:49:07 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Shaohua Li <shli@kernel.org>, linux RAID <linux-raid@vger.kernel.org>, James.Bottomley@hansenpartnership.com
List-Id: linux-raid.ids

>>>>> "Brad" == Brad Campbell <brad@fnarfbargle.com> writes:

>> Discard is broken in 3.7 because the relevant block layer patches
>> went in but James didn't queue the matching SCSI changes.

Brad> http://www.spinics.net/lists/linux-scsi/msg61874.html

Brad> To be clear, if I add patches 6-8 to the current -rc4 I should be
Brad> good to go?

Yep!

-- 
Martin K. Petersen	Oracle Linux Engineering
