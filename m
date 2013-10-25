From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 07:27:19 -0400
Message-ID: <yq1fvrpd208.fsf@sermon.lab.mkp.net>
References: <1969984.qn2lKzvFd6@eseries.newtech.fi>
	<yq1k3h1d3uk.fsf@sermon.lab.mkp.net>
	<25143130.q0O8sfG8vl@eseries.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25143130.q0O8sfG8vl@eseries.newtech.fi> (Dag Nygren's message of
	"Fri, 25 Oct 2013 14:10:02 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: dag@newtech.fi
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Dag" == Dag Nygren <dag@newtech.fi> writes:

Dag> Anyway Neil had the opinion that mdadm could do it outside the
Dag> kernel 

My concern is wrt. making sure that there are no unfortunate
discrepancies between our block device read/write request timeouts and
any error recovery timeouts values set in device firmware.

MD kicking disks is just a symptom that there's a generic issue in this
area.

-- 
Martin K. Petersen	Oracle Linux Engineering
