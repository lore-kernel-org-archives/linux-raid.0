From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid10 on three discs - few questions.
Date: Wed, 06 Feb 2008 17:13:56 -0500
Message-ID: <47AA3124.6080202@tmr.com>
References: <20080203235043.3dbb6433@szpak>	 <18342.18975.229866.860765@notabene.brown> <47A9FFE1.5070001@tmr.com> <cccedfc60802061026s1831aa5fh25eeb151cacf8516@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60802061026s1831aa5fh25eeb151cacf8516@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson wrote:
> On Feb 6, 2008 12:43 PM, Bill Davidsen <davidsen@tmr.com 
> <mailto:davidsen@tmr.com>> wrote:
>
>     Can you create a raid10 with one drive "missing" and add it later? I
>     know, I should try it when I get a machine free... but I'm being
>     lazy today.
>
>
> Yes you can. With 3 drives, however, performance will be awful (at 
> least with layout far, 2 copies).
>
Well, the question didn't include being fast. ;-)

But if he really wants to create the array now and be able to add to it 
later, it might still be useful, particularly if "later" is a small time 
like "when my other drive ships." Thanks for the input, I thought that 
was possible, but reading code isn't the same as testing.
> IMO raid10,f2 is a great balance of speed and redundancy.
> it''s faster than raid5 for reading, about the same for writing. it's 
> even potentially faster than raid0 for reading, actually.
> With 3 disks one should be able to get 3.0 times the speed of one 
> disk, or slightly more, and each stripe involves only *one* disk 
> instead of 2 as it does with raid5.

I have used raid10 swap on 3 or more drives fairly often. Other than the 
Fedora rescue CD not using the space until I start it manually, I find 
it really fast, and helpful for huge image work.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


