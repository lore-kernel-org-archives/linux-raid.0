From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 12 Jun 2013 10:28:03 -0400
Message-ID: <yq138snjte4.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com>
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
	<51AEA4FE.3060900@zytor.com> <yq1mwr4pd9f.fsf@sermon.lab.mkp.net>
	<20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com>
	<yq1bo7ioe6e.fsf@sermon.lab.mkp.net>
	<20130610101505.33b32d07@jlaw-desktop.mno.stratus.com>
	<20130612131543.1c79e077@notabene.brown> <51B7F41F.9000605@zytor.com>
	<51B8153D.1040708@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B8153D.1040708@itwm.fraunhofer.de> (Bernd Schubert's message
	of "Wed, 12 Jun 2013 08:29:17 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, NeilBrown <neilb@suse.de>, Joe Lawrence <joe.lawrence@stratus.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> writes:

Bernd> please correct me if I'm wrong, but I think the code
Bernd> optimistically enabled WRITE_SAME for any drive, except of those
Bernd> on a sata (libata) controller. 

Correct. WRITE SAME has been used extensively by RAID manufacturers for
years. So pretty much any SCSI-class drive supports it.

The headache we ran into in this case was SATA drives behind a SAS
controller.

Bernd> Martins patch should improve that (I still need to test it on our
Bernd> hardware), 

Please do! James wants a tested-by from someone that's not me before he
pushes the patch to Linus.

-- 
Martin K. Petersen	Oracle Linux Engineering
