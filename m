From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 04 Jun 2013 13:54:52 -0400
Message-ID: <yq1d2s1rcb7.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net>
	<CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
	(Dan Williams's message of "Tue, 4 Jun 2013 10:36:53 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Dan" == Dan Williams <dan.j.williams@gmail.com> writes:

>> MD should not consider a rejected WRITE SAME a failure.

Dan> What should md do in the partial success case?  

What exactly do you mean when you say "partial success"? Either the
device accepts the command or it doesn't...


Dan> Maybe just act on BIO_QUIET to retry the write with REQ_WRITE_SAME
Dan> cleared?

No go.

-- 
Martin K. Petersen	Oracle Linux Engineering
