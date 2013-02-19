From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Usefulness of RAID 4
Date: Tue, 19 Feb 2013 15:46:34 -0700
Message-ID: <CBC74AA5-EA3C-4B35-B43E-9C1F12C864CE@colorremedies.com>
References: <D5F9E1BC-26C0-4585-9DD5-0C19570FBA17@colorremedies.com> <5123FF85.50105@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5123FF85.50105@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 19, 2013, at 3:41 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 2/18/2013 9:01 PM, Chris Murphy wrote:
>> Assuming HDD only, is there broad use case for RAID 4 that RAID 5 isn't equally or better suited for?
>> 
>> What about making the parity drive an SSD, keeping the other drives HDD?
> 
> Why are you revisiting RAID-4?

Because it's offered in Fedora 18's GUI installer.

>  It's dead tech, decades ago.  It has no
> advantages over subsequent RAID levels, yet significant handicap.

That's what I thought. But is it remotely practical/useful to use HDDs for data drives, and one SSD as the parity drive to eliminate the parity write bottleneck of RAID 4?


Chris Murphy