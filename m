From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 04 Jun 2013 19:39:58 -0700
Message-ID: <51AEA4FE.3060900@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com> <yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com> <yq18v2prbum.fsf@sermon.lab.mkp.net> <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com> <51AE3441.3000208@zytor.com> <CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/2013 11:56 AM, Dan Williams wrote:
> On Tue, Jun 4, 2013 at 11:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Well, if that is what the block device layer is defined to do then that
>> is what the block layer does.  It makes sense from the point of view of
>> a disk, there block layer has to translate and redo, so if the block
>> layer is defined to do that, why not rely on it?
>>
> 
> I'm just hung up on when we can safely mark the array as not dirty.
> At a minimum this means raid needs a "I have an ignored-write-failure
> in-flight, awaiting retry from upper layer" state.
> 

Ah yes, if you rely on the block layer to retry on you you don't see the
beginnings and ends of the entire transaction, and at least ideally the
RAID -- and the specific blocks -- should be marked dirty during that
operation.  The same applies to DISCARD presumably.

Yuck, this suddenly got complex.  Perhaps WRITE SAME should simply be
disabled on raid1/raid10 until this can be addressed?  Do we need to do
the same for DISCARD?

	-hpa
