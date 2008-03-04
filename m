From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Severe slowdown with LVM on RAID, alignment problem? -
 Autodetect?
Date: Tue, 4 Mar 2008 20:52:48 +0100
Message-ID: <20080304205248.08b92217@szpak>
References: <872d9b69db95a1b08319e935595743cc@localhost>
	<47C7E086.5080203@rabbit.us>
	<47C9C086.4020805@tmr.com>
	<84E2E8E9-9E43-497E-9680-CC0377A8BEDF@it-loops.com>
	<47CB0A9C.7030902@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CB0A9C.7030902@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I was wondering, that maybe someone from our community, skilled
enough, could submit a patch to LVM which will enable autodetection
of RAID stripes in the underlying device?

We would no longer suffer any slowdowns, then ;-)

If LVM cannot communicate with RAID layer (eg. because it's too
difficult, since /dev/md0 is *only* a block device) - then LVM could
do empirical autodetection by writing data to /dev/md0 (*) and
reading data from /dev/sda3 (*), /dev/sdb3 (*) and comparing it.

(*) those are just an example values, of course. They would be a
command line parameters for that ;-)

best regards
-- 
Janek Kozicki                                                         |
