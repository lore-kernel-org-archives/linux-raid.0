From: Elmar Weber <lists@elmarweber.org>
Subject: Re: Raid 1 up after raidhotadd without rebuild
Date: Tue, 14 Nov 2006 10:46:17 +0100
Message-ID: <45599069.6000901@elmarweber.org>
References: <45598C89.6080101@elmarweber.org> <17753.36347.249061.974740@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17753.36347.249061.974740@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday November 14, lists@elmarweber.org wrote:
>> Any ideas why this is and how to fix it?
> 
> You don't mention a kernel version.  If it is 2.6.18, upgrade to
> 2.6.18.2.

Its 2.6.18, I'll upgrade and try, I checked the log and guess it is
"[PATCH] md: Fix bug where spares don't always get rebuilt properly when 
they become live.". Exactly my problem.

Thanks for the fast help.

ciao,
elm
