From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID1: recovery wrongly overrides resync
Date: Mon, 7 Mar 2005 10:54:47 +0100
Message-ID: <d0h82n$t2n$1@sea.gmane.org>
References: <cv5qi1$9eb$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> hdc2/hde2 and when this was finished, recovery took md5 and *recovery*
> started from hda8 to hde8 *without* resync of hdc8. After md5 recovery
>
> Is this a known issue and/or is it fixed in later kernels already?

Hm, I'm wondering, if this got lost or just ignored :)
Is somebody able to follow my description and to reproduce this or do
I need to explain more?


regards,
   Mario
-- 
We are the Bore. Resistance is futile. You will be bored.

