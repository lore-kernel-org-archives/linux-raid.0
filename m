From: Luca Berra <bluca@comedia.it>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Fri, 22 Jul 2011 09:13:20 +0200
Message-ID: <20110722071320.GB19151@maude.comedia.it>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E27FECE.8010201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 21, 2011 at 05:26:22AM -0500, Stan Hoeppner wrote:
>On 7/21/2011 3:11 AM, Pol Hallen wrote:
>> Hello and sorry if I write you in private..
>
>No worries.  I'm taking this back on list as others have more experience
>with this than me.
>
>> about 2Tb wd and 4Kb size, is there a howto to check and correct the size of 
>> these disks?
>> 
>> Can you tell me how?
>
>> 	Model Number:       WDC WD20EARS-00MVWB0                    
>
>1. Can one create a RAID5 from bare (partition-less) AF drives and avoid
>the read-modify-write problem?

until someone proves me wrong i believe 0 is divisible both by 512 and
4096.

L.

-- 
Luca Berra -- bluca@comedia.it
