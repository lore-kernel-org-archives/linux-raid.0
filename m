From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 5 Jun 2013 12:29:32 -0700 (PDT)
Message-ID: <yq1mwr4pd9f.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com>
 <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
 <51AC3283.4000403@zytor.com>
 <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
 <51ACBAA0.40604@zytor.com>
 <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
 <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net>
 <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
 <yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com>
 <yq18v2prbum.fsf@sermon.lab.mkp.net>
 <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com>
 <51AE3441.3000208@zytor.com>
 <CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com>
 <51AEA4FE.3060900@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AEA4FE.3060900@zytor.com> <(H.> <Peter> <Anvin's> <message>
 <of> <"Tue> <> <04> <Jun> <2013> <19:39:58> <-0700")>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>, joe.lawrence@stratus.com
List-Id: linux-raid.ids

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

hpa> Yuck, this suddenly got complex.  Perhaps WRITE SAME should simply
hpa> be disabled on raid1/raid10 until this can be addressed?  

Yeah, maybe.


hpa> Do we need to do the same for DISCARD?

For discard we have better heuristics from the device so the partial
completion case should be rare. But obviously a disk can reject a
command anytime with or without reason...

Also, discard is advisory. There is no guarantee that a pair of mirrored
drives will be consistent in the discarded region (unless the drives
promise to zero discarded blocks but MD doesn't check that for
raid1/raid10).

WRITE SAME requires strict consistency between the devices, however. So
it looks like there's some work that needs to be done in that
department.

-- 
Martin K. Petersen	Oracle Linux Engineering
