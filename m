From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 12 Jun 2013 07:37:33 -0700
Message-ID: <51B887AD.9000302@zytor.com>
References: <51AC1440.7020505@zytor.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com> <yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com> <yq18v2prbum.fsf@sermon.lab.mkp.net> <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com> <51AE3441.3000208@zytor.com> <CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com> <51AEA4FE.3060900@zytor.com> <yq1mwr4pd9f.fsf@sermon.lab.mkp.net> <20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com> <yq1bo7ioe6e.fsf@sermon.lab.mkp.net> <20130610101505.33b32d07@jlaw-desktop.mno.stratus.com> <20130612131543.1c79e077@notabene.brown> <51B
 7F41F.9000605@zytor.com> <yq17ghzjti4.fsf@sermon.lab.mkp.net> <51B885B8.9040600@zytor.com> <yq1txl3iejr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1txl3iejr.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: NeilBrown <neilb@suse.de>, Joe Lawrence <joe.lawrence@stratus.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/12/2013 07:34 AM, Martin K. Petersen wrote:
> 
> I don't believe there are any problems with raid0.
> 

I was wondering if a WRITE SOME sent to raid0 would cause the array to
get stopped or paniced.

	-hpa

