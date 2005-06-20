From: "John Madden" <jmadden@ivytech.edu>
Subject: RE: md multipath restart problem
Date: Mon, 20 Jun 2005 11:04:23 -0500 (EST)
Message-ID: <35258.10.0.15.208.1119283463.squirrel@postal2>
References: <92952AEF1F064042B6EF2522E0EEF4376EE2F3@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF4376EE2F3@EXNA.corp.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Nagpure, Dinesh" <Dinesh.Nagpure@stratus.com>
Cc: linux-raid@vger.kernel.org, "Nagpure, Dinesh" <dinesh.nagpure@stratus.com>
List-Id: linux-raid.ids

> I encountered the bug using RHEL 4, fixed it and then found it already fixed in
> linux-2.6.12-rc2.

Interesting - I'll try upgrading.

> BTW what version of mdadm are you using? just curious, can you fail and then
> re-insert a path to a multipath array and then dump the superblock information
> using mdadm to see both the paths active again? I think paths get activated but
> the superblock is not updated so the information mdadm dumps is sort of incorrect.

I had tried the stock Ubuntu version (1.9.0) and then switched to 1.11.  Failover
works, failback doesn't - the device has to be reinserted manually.  Given the
email notification that mdadm sends out though, I can live with that.

John





-- 
John Madden
UNIX Systems Engineer
Ivy Tech Community College of Indiana
jmadden@ivytech.edu

