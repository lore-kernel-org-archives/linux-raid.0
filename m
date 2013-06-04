From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 04 Jun 2013 14:04:49 -0400
Message-ID: <yq18v2prbum.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net>
	<CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
	<yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AE2A8C.4080508@zytor.com> (H. Peter Anvin's message of "Tue,
	04 Jun 2013 10:57:32 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

hpa> One subdevice accepts it and the other doesn't, presumably.

Ah. Well fail the command and let the block layer deal with it. This is
really no different from the discard case.

-- 
Martin K. Petersen	Oracle Linux Engineering
