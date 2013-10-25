From: Dag Nygren <dag@newtech.fi>
Subject: Re: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 14:35:32 +0300
Message-ID: <1458615.GcNOWxnbko@eseries.newtech.fi>
References: <1969984.qn2lKzvFd6@eseries.newtech.fi> <25143130.q0O8sfG8vl@eseries.newtech.fi> <yq1fvrpd208.fsf@sermon.lab.mkp.net>
Reply-To: dag@newtech.fi
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1fvrpd208.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 25 October 2013 07:27:19 Martin K. Petersen wrote:
> >>>>> "Dag" == Dag Nygren <dag@newtech.fi> writes:
> 
> Dag> Anyway Neil had the opinion that mdadm could do it outside the
> Dag> kernel 
> 
> My concern is wrt. making sure that there are no unfortunate
> discrepancies between our block device read/write request timeouts and
> any error recovery timeouts values set in device firmware.
> 
> MD kicking disks is just a symptom that there's a generic issue in this
> area.

Yep.

That is why this "feature" also should set the timeout to an appropriate value
at the same time. "Just another line of code" ;-)

Best
Dag 

