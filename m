From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Fri, 21 Sep 2012 15:49:53 -0600
Message-ID: <82431340-339F-4C57-B7AC-934316F6DF24@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <CA4BB74E-FBDC-4C8D-A369-BB3CAD859793@colorremedies.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA4BB74E-FBDC-4C8D-A369-BB3CAD859793@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Another thing to check is if your SATA controller has it's own RAID, with RAID vs AHCI modes. If so, make sure it's in AHCI mode. If you have two RAIDs configured and don't know about it, that'll also cause problems.

Chris Murphy