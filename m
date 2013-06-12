From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 12 Jun 2013 10:25:39 -0400
Message-ID: <yq17ghzjti4.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com> <51AC3283.4000403@zytor.com>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B7F41F.9000605@zytor.com> (H. Peter Anvin's message of "Tue,
	11 Jun 2013 21:07:59 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: NeilBrown <neilb@suse.de>, Joe Lawrence <joe.lawrence@stratus.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

>> If a drive has some quirky behaviour wrt WRITE SAME, then that should
>> be handled in some place where 'quirks' are handled - certainly not
>> in md.

hpa> The problem here is that you don't find out ahead of time.

hpa> Now, if I understand the issue at hand correctly is that the
hpa> reporting here was actually a Linux bug related to SATA drives
hpa> behind a SAS controller.  Martin, am I right?

Support for WRITE SAME is harder for us to detect. With discard we have
a set of device-reported bits we can use as triggers, not so for WRITE
SAME. And since it is a destructive command we can not simply issue one
at device discovery time to try whether it works.

Technically there's nothing that prevents a SAS controller's SCSI-ATA
Translation to handle WRITE SAME. The patch I posted simply adds another
heuristic. Namely that if we can see that the drive behind the SAS
controller is of the ATA persuasion we will not attempt to issue WRITE
SAME unless the controller explicitly advertises WRITE SAME support
using REPORT SUPPORTED OPERATION CODES.

Sadly we can not exclusively rely on RSOC when deciding whether WRITE
SAME is supported or not for devices in general. 95% of the WRITE
SAME-capable devices out there do not support RSOC :(

-- 
Martin K. Petersen	Oracle Linux Engineering
