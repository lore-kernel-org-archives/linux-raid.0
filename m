From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Interesting article
Date: Thu, 15 Jan 2009 01:09:44 -0800 (PST)
Message-ID: <148335.68682.qm@web51311.mail.re2.yahoo.com>
References: <496E44DE.7090200@harddata.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496E44DE.7090200@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Maurice Hilarius <maurice@harddata.com>
List-Id: linux-raid.ids

I have read about this previously and what i turned up then was that it is true, a failed drive can cause others to fail.. particularly if the drives are old and haven't been regularly made to sweat!

My setup is 2x320GB mirrored 6x500GB RAID 5 with 1 off them as a spare (for now) - all SW raid.. and with an LVM ontop.

I do checks 6 days a week on each of the drives using smartctl and monitor the results - I rotate through the long and short checks so that i dont have 6 drives all doing long checks on the same day! (really effects performance when streaming video from it!)

I also do a raid 'scrub' (check) once a week and if there is an error i do a repair.

Also, when i 'grow' one of the LV's i do a e2fsck -cc on it to 'flush' out any bad sectors by reading AND writing.

This has actually done just this and one of my drives is now showing 800 reallocated sectors! (it is going back)

As a result of this i now plan to do monthly individual drive checks by dismantling the array and running bad blocks on the individual drives.

The point of all this is to flush out any bad sectors before they get chance to be a problem.

I also do a nightly copy of the files I absolutely can not do without (Photos et al) to the mirrored 320GB drives.... (as well as 6monthly DVD's)

Hope this is of interest to someone!

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'..Be fearful when others are greedy, and be greedy when others are fearful.'
-----------------------


--- On Wed, 14/1/09, Maurice Hilarius <maurice@harddata.com> wrote:

> From: Maurice Hilarius <maurice@harddata.com>
> Subject: Interesting article
> To: linux-raid@vger.kernel.org
> Date: Wednesday, 14 January, 2009, 8:02 PM
> I read this today:
> http://blogs.zdnet.com/storage/?p=162
> 
> Would anyone who knows enough about this care to comment?
> 
> Thanks in advance for any thoughts..
> 
> 
> -- 
> With our best regards,
> 
> //Maurice W. Hilarius         Telephone: 01-780-456-9771/
> /Hard Data Ltd.                FAX:         
> 01-780-456-9772/
> /11060 - 166 Avenue         email:maurice@harddata.com/
> /Edmonton, AB, Canada/
> /     T5X 1Y3/
> /
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
