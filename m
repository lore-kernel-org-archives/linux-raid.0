From: Wim Vinckier <wim-raid@tisnix.be>
Subject: Re: total devices 1 too many
Date: Fri, 17 Jan 2003 11:30:51 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0301171121001.17249-100000@nooks.wimpunk.com>
References: <Pine.LNX.4.51.0301152357520.8266@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.51.0301152357520.8266@twinlark.arctic.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I don't know if this is the exact list to post my message but I give it a
try ;-)
I have a promise ultra100tx2 with 4 disks which are both running in a
raid-1 configuration.  Last week I had to modify my kernel (2.4.18) but
unfortunaly, I couldn't find the configuration I used to make my previous
kernel.  Since I'm using my new kernel (it was running for a few days
before I got the first errors) I get errors like

Jan 15 10:32:51 benlossen kernel: hdg: status error: status=0x58 {
DriveReady SeekComplete DataRequest }
Jan 15 10:32:51 benlossen kernel: hdg: drive not ready for command
Jan 15 10:32:51 benlossen kernel: hdg: status timeout: status=0xd0 { Busy
}
Jan 15 10:32:51 benlossen kernel: hdg: drive not ready for command
Jan 15 10:32:51 benlossen kernel: ide3: reset: success


Does anyone has an idea what I did wrong?

Wim.
------------------------------------------------------------------------
Wim VINCKIER
Wasstraat 38                                          Wim-Raid@tisnix.be
B-9000  Gent                                               ICQ 100545109
------------------------------------------------------------------------
'Windows 98 or better required' said the box... so I installed linux

