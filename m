From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Problem with DISCARD and RAID10
Date: Thu, 08 Nov 2012 01:14:37 +0800
Message-ID: <509A96FD.2020706@fnarfbargle.com>
References: <5098D92A.3000503@fnarfbargle.com> <20121106114017.GB19182@kernel.org> <yq1pq3q4apw.fsf@sermon.lab.mkp.net> <5099DA33.8050406@fnarfbargle.com> <yq1obj92zi8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1obj92zi8.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaohua Li <shli@kernel.org>, linux RAID <linux-raid@vger.kernel.org>, James.Bottomley@hansenpartnership.com
List-Id: linux-raid.ids

On 07/11/12 23:39, Martin K. Petersen wrote:
>>>>>> "Brad" == Brad Campbell <brad@fnarfbargle.com> writes:
>
>>> Discard is broken in 3.7 because the relevant block layer patches
>>> went in but James didn't queue the matching SCSI changes.
>
> Brad> http://www.spinics.net/lists/linux-scsi/msg61874.html
>
> Brad> To be clear, if I add patches 6-8 to the current -rc4 I should be
> Brad> good to go?
>
> Yep!
>

Can confirm that with those patches applied DISCARD behaves in a 
predictable and verifiable fashion on my RAID10. Cheers!

Regards,
Brad
