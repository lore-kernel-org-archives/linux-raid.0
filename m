From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Mon, 03 Jun 2013 15:20:25 -0700
Message-ID: <51AD16A9.7010509@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51ACE32F.1060702@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51ACE32F.1060702@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/03/2013 11:40 AM, H. Peter Anvin wrote:
> On 06/03/2013 11:35 AM, Martin K. Petersen wrote:
>>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
>>
>> hpa> OK, so the device here says don't do this again, but fails the
>> hpa> request anyway expecting the block device to pick up the slack.
>>
>> Yes, the block layer function will resort to writing out zeroes directly
>> in this case.
>>
>> MD should not consider a rejected WRITE SAME a failure.
>>
> 
> Presumably MD should do the same thing that SCSI does: disable
> write_same and kick the failure upstack?
> 

Also, given the seriousness of the failure mode, is this something that
should be addressed in stable?

	-hpa

