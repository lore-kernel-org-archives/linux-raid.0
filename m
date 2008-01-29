From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 09:57:48 -0600
Message-ID: <479F4CFC.5060305@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F3C74.1050605@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:

> [*] The layout is the same but the functionality is different. If you 
> have 1+0 on 4 drives, you can survive a loss of 2 drives as long as they 
> are part of different mirrors. mdadm -C -l 10 -n 4 -o n2 <drives> 
> however will _NOT_ survive a loss of 2 drives.

In my 4 drive system, I'm clearly not getting 1+0's ability to use grub 
out of the RAID10.  I expect it's because I used 1.2 superblocks (why 
not use the latest, I said, foolishly...) and therefore the RAID10 -- 
with even number of drives -- can't be read by grub. If you'd patch that 
information into the man pages that'd be very useful indeed.

Thanks for your attention to this!

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "no user serviceable parts below this line"
    				-- From a Perl program by mengwong@pobox.com
