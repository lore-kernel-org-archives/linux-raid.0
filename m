From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid10 on three discs - few questions.
Date: Wed, 6 Feb 2008 12:28:57 -0600
Message-ID: <cccedfc60802061028x4c87d52bn88ff305e3bbe5e36@mail.gmail.com>
References: <20080203235043.3dbb6433@szpak>
	 <18342.18975.229866.860765@notabene.brown> <47A9FFE1.5070001@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A9FFE1.5070001@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Feb 6, 2008 12:43 PM, Bill Davidsen <davidsen@tmr.com> wrote:

> Can you create a raid10 with one drive "missing" and add it later? I
> know, I should try it when I get a machine free... but I'm being lazy today.

Yes you can. With 3 drives, however, performance will be awful (at
least with layout far, 2 copies).

IMO raid10,f2 is a great balance of speed and redundancy.
it''s faster than raid5 for reading, about the same for writing. it's
even potentially faster than raid0 for reading, actually.
With 3 disks one should be able to get 3.0 times the speed of one
disk, or slightly more, and each stripe involves only *one* disk
instead of 2 as it does with raid5.

-- 
Jon
