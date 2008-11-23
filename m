From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Why does the md/raid subsystem does not remap bad sectors in a
	raid   array?
Date: Sun, 23 Nov 2008 10:20:41 -0200
Message-ID: <20081123122041.GC17607@khazad-dum.debian.net>
References: <alpine.DEB.1.10.0811221859210.14817@p34.internal.lan> <4928B580.5040800@shaw.ca> <4928DD4C.4020301@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4928DD4C.4020301@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 23 Nov 2008, Brad Campbell wrote:
> md has done this for a while now though. If it encounters a read error in 
> the array it will make an attempt to write the reconstructed data back to 
> that disk attempting to force a reallocation. I've seen it work quite 
> well here on disks that have the occasional grown defect.

Indeed, but it does so in the "check array" mode (which distros like
Debian are now enabling once-a-month or so, I always up that to once a
week :p)

Does md repair bitrotten sectors ALSO outside of check mode?  That's
what is being asked in this thread...

> If the disk is haemorrhaging sectors then you will find out about it 
> sooner or later through other means.

Like a weekly SMART long test.   That's what our maintenance windows are
for :)  Everything is kept on-line, but allowed to run in degraded
performance mode, so we kick in SMART offline and long tests, RAID array
scrubbing, etc (not at the same time, though!).

That reminds me to file a bug against smartmontools to DISABLE auto
offline mode on disks, and enable them one disk at a time at a random
interval with at least one hour between them.  Otherwise, the disks all
enter auto-offline-testing SMART mode at the same time.

Hmm, it would be good to teach md to measure disk throughput using a
sliding window (of say, 5 minutes) and reduce read priority of disks
that are slow...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
