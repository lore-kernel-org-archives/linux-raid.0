From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Usefulness of RAID 4
Date: Wed, 20 Feb 2013 12:15:50 -0600
Message-ID: <512512D6.6080104@hardwarefreak.com>
References: <D5F9E1BC-26C0-4585-9DD5-0C19570FBA17@colorremedies.com> <5123FF85.50105@hardwarefreak.com> <CBC74AA5-EA3C-4B35-B43E-9C1F12C864CE@colorremedies.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CBC74AA5-EA3C-4B35-B43E-9C1F12C864CE@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/19/2013 4:46 PM, Chris Murphy wrote:

> But is it remotely practical/useful to use HDDs for data drives, and one SSD as the parity drive to eliminate the parity write bottleneck of RAID 4?

I don't see how.  The SSD dedicated to parity must have the same
capacity as the HDDs.  The largest non PCIe monster SDDs are right at
1TB and the cheapest of those is ~$1000.  If the goal is to do an end
run around slow parity writes of RAID4, then RAID10/0+1/etc with HDDs
gives a lot more capacity and performance for the same or less money.

Hybrid RAID4 setup:
2TB net capacity
Mushkin Enhanced 2.5" 960GB =	$1000
2x Hitachi 1TB 7.2K 2.5" =	$ 200
				$1200
RAID10 setup:
6TB net capacity
12x Hitachi 1TB 7.2K 2.5" =	$1200

The RAID10 setup has 3x write performance and capacity for the same
money, albeit with more power draw and more ports required.

-- 
Stan

