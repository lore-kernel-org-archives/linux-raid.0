From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: recovering failed raid5
Date: Mon, 31 Oct 2016 16:31:22 +0000
Message-ID: <581771DA.9030108@youngman.org.uk>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, linux-raid@vger.kernel.org
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, rm@romanrm.net, robin@robinhill.me.uk
List-Id: linux-raid.ids

On 28/10/16 13:22, Alexander Shenkin wrote:
>> But... why? Why disable smart? And if you do, is it a surprise that you
>> only notice disk failures when it's already too late?
> 
> yeah, i asked myself that same question.  there was probably some reason
> I did, but i don't remember what it was.  i'll keep smart enabled from
> now on...

I bet he didn't disable smarts - bear in mind I also have two 3TB
Barracudas ... and they lose their settings at power-off/on.

If he didn't set the boot process to explicitly turn smart on, EVERY
BOOT, then by default it's off.

Cheers,
Wol
