From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: raid5 or raid6 and the maximum size
Date: Thu, 22 Sep 2005 15:52:08 +0200
Message-ID: <dgucu8$66q$1@sea.gmane.org>
References: <4332AD95.1080904@bppiac.hu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente <lfarkas@bppiac.hu> wrote:
> - 7 x 300GB in raid5 and one 300GB spare or
> - 8 x 300GB in raid6?
> it seems the same to me since both case we can get two disk faild and 

No, it's everything but the same. raid5 always gives you survival of exactly
one simultaneous disk failure. If two of your disks fail simultaneously
in a raid5, you're lost. A spare disk gets used not before any disk
failed. Then it needs time to get synched, where you have no redundancy
at all. After that your raid5 is able to survive another disk failure.


regards
   Mario
-- 
As a rule, the more bizarre a thing is, the less mysterious it proves to be.
                                    -- Sherlock Holmes by Arthur Conan Doyle

