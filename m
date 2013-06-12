From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 12 Jun 2013 10:34:00 -0400
Message-ID: <yq1txl3iejr.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com> <51ACBAA0.40604@zytor.com>
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
	<yq17ghzjti4.fsf@sermon.lab.mkp.net> <51B885B8.9040600@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B885B8.9040600@zytor.com> (H. Peter Anvin's message of "Wed,
	12 Jun 2013 07:29:12 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.de>, Joe Lawrence <joe.lawrence@stratus.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

hpa> The second question is if we should disable WRITE SAME for raid1/10
hpa> (what about raid0?) for 3.10/stable or if your patch really is
hpa> sufficient... "just adds another heuristic" makes me nervous.

I think we should disable 1+10 in stable until we get the recovery
scenario sorted out.

I don't believe there are any problems with raid0.

-- 
Martin K. Petersen	Oracle Linux Engineering
