From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Sun, 27 Jan 2013 18:42:43 -0700
Message-ID: <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <5105D0EA.7080100@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5105D0EA.7080100@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are the drives all the same model? What model? And are they AF disks?

The mismatch number is not divisible by 16, yet your chunk size is 16KB. It is divisible by 4 and 8, so I'm going to guess that the physical sector size is 4096 bytes. If correct, I'm coming up with a maximum of 346GiB worth of sectors may be adversely affected, assuming every sector in the mismatch count is bad (which is probably not true, but could be).

What file system?

Have you done only a check or also a repair, either before or after the upgrade? (I'm not suggesting doing a repair now.)

A check should cause URE's to be fixed, but you don't get a count against them because chunk and parity end up being the same for the check after being fixed.

Are there any messages in dmesg for the time of the check? I would like to know what was recorded in dmesg at the time the mismatches were found.

Chris Murphy