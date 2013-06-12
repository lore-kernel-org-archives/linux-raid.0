From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 12 Jun 2013 08:58:05 -0700
Message-ID: <51B89A8D.1080301@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com> <yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com> <yq18v2prbum.fsf@sermon.lab.mkp.net> <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com> <51AE3441.3000208@zytor.com> <CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com> <51AEA4FE.3060900@zytor.com> <yq1mwr4pd9f.fsf@sermon.lab.mkp.net> <20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com> <yq1bo7ioe6e.fsf@sermon.lab.mkp.net> <20130610101505.33b32d07@jlaw-desktop.mno.stratus.com> <20130612131543.1c79e077@notabene.brown> <51B7F41F.9000605@zytor.com> <y
 q17ghzjti4.fsf@sermon.lab.mkp.net> <51B885B8.9040600@zytor.com> <yq1txl3iejr.fsf@sermon.lab.mkp.net> <51B8897C.8000801@zytor.com> <5AA430FFE4486C448003201AC83BC85E0360CE3F@EXHQ.corp.stratus!
 .com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5AA430FFE4486C448003201AC83BC85E0360CE3F@EXHQ.corp.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Lawrence, Joe" <Joe.Lawrence@stratus.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.de>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/12/2013 08:55 AM, Lawrence, Joe wrote:
> This looks exactly like what I started last night, only with a more detailed commit msg.  Would it be worth mentioning that block will only retry if MD fails the master bio?  (Ie, if one of mirrored components succeed the WS)

Probably not... the big deal here is that it isn't a viable solution due
to the write bitmap fence.

	-hpa


