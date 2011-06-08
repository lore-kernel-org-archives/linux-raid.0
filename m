From: David Brown <david@westcontrol.com>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Wed, 08 Jun 2011 11:43:56 +0200
Message-ID: <isnga2$a7g$1@dough.gmane.org>
References: <4DEE6A11.1030205@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEE6A11.1030205@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/06/2011 20:12, Stefan G. Weichinger wrote:
>
> Greetings, could you please advise me how to proceed?
>
> On a server I have 2 RAID1-arrays, each consisting of 2 TB-drives:
>
> md5 : active raid1 sde1[0] sdf1[1]
>        976759936 blocks [2/2] [UU]
>
> md6 : active raid1 sdh1[1] sdg1[0]
>        976759936 blocks [2/2] [UU]
>
>
> md5 and md6 are right now physical volumes (PVs) in an LVM-volume-group.
> Nearly all the space is used right now (1.7 TB out of the ~2 TB).
>
> Now I would like to move things to a more reliable RAID6 consisting of
> all the four TB-drives ...
>
> How to do that with minimum risk?
>
> For sure it would be best to move all data aside, stop the arrays and
> build a new one ... etc
>
> Failing two drives and remove them from the RAID1s to build a new
> degraded RAID6 seems dangerous to me?
>
> Maybe I overlook a clever alternative?
>
> Suggestions welcome, thanks in advance.
>

This may be stating the obvious, but you do realise that converting to a 
four-disk RAID6 will not give you any more space?

You might want to consider replacing the drives when you do your 
re-shaping or rebuilding (whether you go for RAID6 or RAID10,far).



