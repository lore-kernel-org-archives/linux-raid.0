From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Thu, 6 Jun 2013 19:19:37 -0700 (PDT)
Message-ID: <yq1bo7ioe6e.fsf@sermon.lab.mkp.net>
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
 <51AEA4FE.3060900@zytor.com> <yq1mwr4pd9f.fsf@sermon.lab.mkp.net>
 <20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com> <(Joe>
 <Lawrence's> <message> <of> <"Thu> <> <6> <Jun> <2013> <14:27:47> <-0400")>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Joe" == Joe Lawrence <joe.lawrence@stratus.com> writes:

Joe> I'm looking at the changes in raid1.c and am confused as to why we
Joe> did this in the first place (commit c8dc9c6):

Joe>         if (mddev->queue)
Joe>                 blk_queue_max_write_same_sectors(mddev->queue, mddev-> chunk_sectors);

Joe> for RAID1, aren't chunk_sectors always going to be zero?  (At least
Joe> on my machine, /sys/block/md*/queue/write_same_max_bytes for all md
Joe> RAID1 devices are set to 0.)  This would have the effect of
Joe> rendering bdev_write_same() always false for these MD devices.

I'm guessing that's a copy and paste from my raid0 support. In the raid0
case I set it to prevent straddling discard/write same commands.

-- 
Martin K. Petersen	Oracle Linux Engineering
