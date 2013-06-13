From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Thu, 13 Jun 2013 17:40:42 -0400
Message-ID: <yq1y5adelk5.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net>
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
	<yq1txl3iejr.fsf@sermon.lab.mkp.net> <51B8897C.8000801@zytor.com>
	<20130613131051.25d5730d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130613131051.25d5730d@notabene.brown> (NeilBrown's message of
	"Thu, 13 Jun 2013 13:10:51 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Lawrence <joe.lawrence@stratus.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

Neil> But I'm pretty sure raid5 will do the wrong thing with a
Neil> WRITE_SAME request.

Yeah, you should set: 

	mddev->queue->max_write_same_blocks = 0;

before disk_stack_limits() is called. Just like it's done with
discard_zeroes_data.

-- 
Martin K. Petersen	Oracle Linux Engineering
