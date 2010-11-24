From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: raid related kernel hang in 2.6.36
Date: Wed, 24 Nov 2010 19:15:26 -0200
Message-ID: <19693.32878.255666.504304@fisica.ufpr.br>
References: <4CED17A4.7050604@perabytes.com>
	<AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>
	<4CED226D.6090602@perabytes.com>
	<20101125070155.277a0d62@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101125070155.277a0d62@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Du Jun <dujun@perabytes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 25 November 2010 07:01:
 >On Wed, 24 Nov 2010 22:34:21 +0800 Du Jun <dujun@perabytes.com> wrote:
 >
 >> Their's no dmesg information at all before the hang. The system just 
 >> hangs suddenly without any kernel printk or oops.
 >> 
 >> mdadm version is debian lenny version 2.6.7.2-3
 >> 
 >> I will get mdadm -E & mdadm -D informations tomorrow but I doubt they 
 >> are useful.
 >
 >Probably not, but they wouldn't hurt either.
 >
 >What would really help is if you could capture the result of
 >    sysrq-T
 >
 >which I accept might be a challenge depending on how hard the machine really
 >has frozen.
 >
 >Also, make sure the LOCKUP_DETECTOR config options are set, and wait a few
 >minutes after the hand to see if something pops up.

You could also boot with the NMI watchdog. Using netconsole to capture
the full traces would be useful as well.
