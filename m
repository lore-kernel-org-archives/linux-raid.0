From: Neil Brown <neilb@suse.de>
Subject: Re: New RAID causing system lockups
Date: Tue, 14 Sep 2010 13:48:37 +1000
Message-ID: <20100914134837.2e740a3e@notabene>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
	<AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
	<AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
	<AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
	<20100914095111.6e3045c7@notabene>
	<AANLkTin=jy=xJTtN5mQ6U=rYw3p+_4-nmkhO7zqR0KLP@mail.gmail.com>
	<AANLkTimyEr9LnS2BOR+rXhwfU0rCE-MmYcjttaTyqAWT@mail.gmail.com>
	<20100914113516.63c883c4@notabene>
	<AANLkTimeeecqZX1Bn23=_41sBYO+P8h_b5Z6Gf_ACuA1@mail.gmail.com>
	<AANLkTi=uO6a1e_eGKcg6T2rD_ZpqNg_-X1u6qq=zA5J6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=uO6a1e_eGKcg6T2rD_ZpqNg_-X1u6qq=zA5J6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 13 Sep 2010 23:35:50 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> Sorry Neil, locked up again in less than an hour. I've uploaded
> dmesg_5.txt in case the trace shows something different/useful in
> light of your patch.
> 
> Mike


Hmmm..
 Can you try mounting with 
    -o barrier=0

just to see if my theory is at all correct?

Thanks,
NeilBrown
