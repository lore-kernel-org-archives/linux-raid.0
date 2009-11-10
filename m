From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: 11 Nov 2009 00:03:02 +0100
Message-ID: <m3fx8m3rvd.fsf@mobydick.mine.nu>
References: <4AF7066C.1040507@tmr.com>
	<f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911101031q7184315g24ba345dd30e55fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911101031q7184315g24ba345dd30e55fd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "\"Majed B.\"" <majedb@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

majedb@gmail.com ("Majed B.") writes:
> Chris,
> 
> Do you mind sharing the drive models & controllers you're using that
> give you 800 MB/s?

At work we reviewed different kind of fusion-io products (namely ioDrive
and ioDrive-Duo, 80GB and 640GB) and I could easily get 700 MB/s with
more than 100k iops (benched using fio)...

http://kb.fusionio.com/KB/a29/verifying-linux-system-performance.aspx

Their results are consistent with what I saw...

I didn't like the binary like driver though...
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
