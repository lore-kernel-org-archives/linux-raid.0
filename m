From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: idle array consuming cpu ??!!
Date: Tue, 22 Jan 2008 00:25:01 -0200
Message-ID: <18325.21501.507878.267465@fisica.ufpr.br>
References: <18323.53904.556620.19761@fisica.ufpr.br>
	<18323.61999.693738.678224@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18323.61999.693738.678224@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 21 January 2008 12:15:
 >On Sunday January 20, carlos@fisica.ufpr.br wrote:
 >> A raid6 array with a spare and bitmap is idle: not mounted and with no
 >> IO to it or any of its disks (obviously), as shown by iostat. However
 >> it's consuming cpu: since reboot it used about 11min in 24h, which is quite
 >> a lot even for a busy array (the cpus are fast). The array was cleanly
 >> shutdown so there's been no reconstruction/check or anything else.
 >> 
 >> How can this be? Kernel is 2.6.22.16 with the two patches for the
 >> deadlock ("[PATCH 004 of 4] md: Fix an occasional deadlock in raid5 -
 >> FIX") and the previous one.
 >
 >Maybe the bitmap code is waking up regularly to do nothing.
 >
 >Would you be happy to experiment?  Remove the bitmap with
 >   mdadm --grow /dev/mdX --bitmap=none
 >
 >and see how that affects cpu usage?

Confirmed, removing the bitmap stopped cpu consumption.
