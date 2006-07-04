From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Tue, 4 Jul 2006 14:19:49 +0200
Message-ID: <e8dmd5$kek$1@sea.gmane.org>
References: <20060702224549.GD12733@percy.comedia.it> <17576.21342.685662.432117@cse.unsw.edu.au> <44AA42F6.8070307@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> Why to test for udev at all?  If the device does not exist, regardless
> if udev is running or not, it might be a good idea to try to create it.
> Because IT IS NEEDED, period.  Whenever the operation fails or not, and

Perhaps it was just a typo and you damage more if you just create it.
Typical behaviour is to *not* just create device nodes because they
don't exist but instead assume administrators know what they do.
That's why I personally think it's better to rely on administrator's
decision about automatic creation of device nodes.


regards
   Mario
-- 
As a rule, the more bizarre a thing is, the less mysterious it proves to be.
                                    -- Sherlock Holmes by Arthur Conan Doyle

