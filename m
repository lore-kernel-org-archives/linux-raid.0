From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 11 Jun 2013 21:07:59 -0700
Message-ID: <51B7F41F.9000605@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com> <yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com> <yq18v2prbum.fsf@sermon.lab.mkp.net> <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com> <51AE3441.3000208@zytor.com> <CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com> <51AEA4FE.3060900@zytor.com> <yq1mwr4pd9f.fsf@sermon.lab.mkp.net> <20130606142747.1fc17b7f@
 jlaw-desktop.mno.stratus.com> <yq1bo7ioe6e.fsf@sermon.lab.mkp.net> <20130610101505.33b32d07@jlaw-desktop.mno.stratus.com> <20130612131543.1c79e077@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130612131543.1c79e077@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/11/2013 08:15 PM, NeilBrown wrote:
> If a drive reports that WRITE SAME works, but it doesn't, then I'm
> not sure that I can be happy about working with that drive.

Seriously... we have that kind of problems all over the place with all
kinds of hardware.  Falling back is sensible... the problem here is
*where* that needs to happen... the block layer already does, apparently.

> If a drive has some quirky behaviour wrt WRITE SAME, then that
> should be handled in some place where 'quirks' are handled -
> certainly not in md.

The problem here is that you don't find out ahead of time.

Now, if I understand the issue at hand correctly is that the reporting
here was actually a Linux bug related to SATA drives behind a SAS
controller.  Martin, am I right?

	-hpa


