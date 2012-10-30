From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Mon, 29 Oct 2012 23:49:47 -0500
Message-ID: <508F5C6B.6060304@hardwarefreak.com>
References: <CACY-59cbWX9Gu_xsfqv_p8=Q7CabWZuj=ZH2K41j4N0-o-8WLw@mail.gmail.com> <2012102411171145340220@meganovo.com>,  <20121024161440.239ea8b8@notabene.brown> <201210301018322655420@meganovo.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210301018322655420@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: GuoZhong Han <hanguozhong@meganovo.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, neilb <neilb@suse.de>, =?UTF-8?B?6buE5pil6L6J?= <childhood@meganovo.com>
List-Id: linux-raid.ids

On 10/29/2012 9:19 PM, hanguozhong wrote:

>     The disks were plugged in the device via 2 2680 Rocket cards. Each Rocket card supported at most 8 disks.

Card: HighPoint RocketRAID 2680/2680SGL Marvell 88SE6485
Driver: MVSAS

After years of development the MVSAS driver is still not suitable for
production use.  It is the cause of your problems here.  Any board using
the Marvell SAS chips is not suitable for use with Linux at this time
due to the poor driver quality.  These boards work fine under Windows
apparently.

>     2012-10-27 23:57:04 ata9.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6 t0
>     2012-10-27 23:57:04 ata9.00: failed command: READ FPDMA QUEUED
>     2012-10-27 23:57:04 ata9.00: cmd 60/00:00:80:62:a7/04:00:d6:00:00/40 tag 0 ncq 524288 in
>     2012-10-27 23:57:04          res 01/04:b4:80:ca:a7/00:00:d6:00:00/40 Emask 0x2 (HSM violation)
<snip>
>     2012-10-27 23:57:07 ata9.00: configured for UDMA/133
>     2012-10-27 23:57:07 ata9: EH complete
<snip>
>     My problem seems not really be solved, can you help me? I would be very grateful to you.

Yes, I can help.  Replace the HighPoint boards with LSI 9211-8i boards
and everything should work fine, barring any compatibility issue with
the Tilera platform.

-- 
Stan


