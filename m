From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 4 Jun 2013 10:36:53 -0700
Message-ID: <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com>
	<yq1y5art543.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1y5art543.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 3, 2013 at 11:35 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
>
> hpa> OK, so the device here says don't do this again, but fails the
> hpa> request anyway expecting the block device to pick up the slack.
>
> Yes, the block layer function will resort to writing out zeroes directly
> in this case.
>
> MD should not consider a rejected WRITE SAME a failure.

What should md do in the partial success case?  Seems to be a layering
violation to assume that the block layer will retry with zeroes.
Maybe just act on BIO_QUIET to retry the write with REQ_WRITE_SAME
cleared?

--
Dan
