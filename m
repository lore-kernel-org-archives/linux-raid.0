From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Problem with DISCARD and RAID10
Date: Wed, 07 Nov 2012 11:49:07 +0800
Message-ID: <5099DA33.8050406@fnarfbargle.com>
References: <5098D92A.3000503@fnarfbargle.com> <20121106114017.GB19182@kernel.org> <yq1pq3q4apw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1pq3q4apw.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaohua Li <shli@kernel.org>, linux RAID <linux-raid@vger.kernel.org>, James.Bottomley@hansenpartnership.com
List-Id: linux-raid.ids

On 07/11/12 06:39, Martin K. Petersen wrote:
>>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:
>
> Shaohua> cc Martin to check if he has idea.
>
> Shaohua> Hmm, I thought such problem is already fixed by Martin's
> Shaohua> discard merge patches and my last test in SATA SSD doesn't show
> Shaohua> this problem.
>
> Discard is broken in 3.7 because the relevant block layer patches went
> in but James didn't queue the matching SCSI changes.
>

http://www.spinics.net/lists/linux-scsi/msg61874.html

To be clear, if I add patches 6-8 to the current -rc4 I should be good 
to go?

Regards,
Brad
