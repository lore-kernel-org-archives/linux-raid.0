From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Wed, 16 Jan 2013 16:06:39 -0600
Message-ID: <50F7246F.2040004@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301142052.06390.thomas@fjellstrom.ca> <50F5157A.2080308@hardwarefreak.com> <201301152231.43704.thomas@fjellstrom.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301152231.43704.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/15/2013 11:31 PM, Thomas Fjellstrom wrote:

> That gets me thinking. Maybe try a test with the record test size set to the 
> stripe width, that would hopefully show some more accurate numbers.

That will give you less accurate numbers, if you're looking for numbers
that reflect real world performance.  Again, in general, most real world
writes are not stripe aligned, and not full width, especially with the
insanely large 512KB chunk size.

For all but a few workloads, storage should be designed and optimized
assuming most writes will be unaligned or not full width, -not- assuming
most will be full stripe writes.

-- 
Stan



