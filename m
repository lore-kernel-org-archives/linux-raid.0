From: Neil Brown <neilb@suse.de>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Thu, 11 Jun 2015 17:02:57 +1000
Message-ID: <20150611170257.7033d835@home.neil.brown.name>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
	<20150610101942.0bc26a25@home.neil.brown.name>
	<20150610115721.64c474fa@home.neil.brown.name>
	<wrfjk2vbv894.fsf@carbonite.lan.trained-monkey.org>
	<20150611164847.7cd87c13@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150611164847.7cd87c13@home.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

On Thu, 11 Jun 2015 16:48:47 +1000
Neil Brown <neilb@suse.de> wrote:


> Would you be able to test with the following patch?  There is a chance it might
> confirm whether two sync threads are running at the same time.


I tried the patch, and was fortunate:

[  208.626468] Register thread ffff88003cf53d00 md0_resync
[  208.629801] Started thread ffff88003cf53d00 md0_resync
[  208.629801] Finished thread ffff88003cf53d00
[  208.639800] Reap thread ffff88003cf53d00
[  208.639800] Finished thread ffff88003cf53d00 md0_resync
[  208.643133] Register thread ffff88003cf53700 md0_resync
[  208.643133] Reap thread           (null)
[  208.646466] Started thread ffff88003cf53700 md0_resync
[  208.659799] Reap thread ffff88003cf53700
-HANG-

That "(null)" is a problem - that will clear MD_RECOVERY_RUNNING, but there
is a thread there.
Will keep looking.

NeilBrown
