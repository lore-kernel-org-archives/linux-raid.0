From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 04 Jun 2013 11:56:23 -0400
Message-ID: <yq1bo7lswd4.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net>
	<51ACE32F.1060702@zytor.com> <51AD16A9.7010509@zytor.com>
	<51AD19EF.1070604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AD19EF.1070604@zytor.com> (H. Peter Anvin's message of "Mon,
	03 Jun 2013 15:34:23 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

hpa> Note that the filesystem is not mounted with the "discard" option,
hpa> and given the rarity of the aborts, whatever causes the WRITE SAME
hpa> bio to be generated must be a very rare event.

It's probably not discard. I'm guessing it's something that needs to
zero out a block range. Not something that happens very often.

-- 
Martin K. Petersen	Oracle Linux Engineering
