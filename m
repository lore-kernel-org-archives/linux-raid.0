From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Re: Disks never stop spinning
Date: Sat, 06 Dec 2014 16:16:23 +0100
Message-ID: <54831DC7.4070304@gautschi.net>
References: <54610788.6060103@gautschi.net> <21604.47814.651762.246947@tree.ty.sabi.co.uk> <54657187.6020306@gautschi.net> <5480B726.8070103@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5480B726.8070103@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 > Are you running udisks?  If so then that is the culprit.  It polls the
 > drive's SMART stats every 10 minutes unless the drive is already
 > asleep, so if the timeout is>= 10 minutes ( which it seems WD drives
 > refuse to go any lower anyhow ), then the drive will never go to
 > standby.  I posted some patches to fix this a while back on the
 > devkit-devel mailing list but I think the udisks maintainer has still
 > not gotten around to applying them.

This is indeed the cause in my case. There are the two problems that
overlap: if a shorter time then 10 minutes is set as a standby time,
the WD disk rounds this up to 10 minutes.
And Kubuntu is using udisksd. It is started during a KDE login and
never stopped when logging out.

Is it possible to configure udisks to not do any polling or at a much
longer interval? Or is it possible to safely disable udisksd somehow?
I'm still looking for a practical solution.

regards
Patrick
