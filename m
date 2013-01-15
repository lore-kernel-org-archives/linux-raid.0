From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 17:13:04 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301151711220.12098@uplift.swm.pp.se>
References: <20130115123301.GA11948@rabbit.us> <alpine.DEB.2.00.1301151344500.12098@uplift.swm.pp.se> <20130115125633.GB12184@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130115125633.GB12184@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Jan 2013, Peter Rabbitson wrote:

> http://paste.debian.net/224907/

Looks like sda is slower than the rest of the drives for some reason (see 
last column):

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb           14909.80     0.00  117.40    0.00 120217.60     0.00  1024.00     0.47    3.99   3.99  46.80
sdc           14779.80     0.00  234.80    0.00 120115.20     0.00   511.56     0.53    2.26   2.03  47.76
sdd           14884.40     0.00  117.40    0.00 120217.60     0.00  1024.00     0.52    4.45   4.44  52.16
sda           14779.80     0.00  234.40    0.00 120012.80     0.00   512.00     1.79    7.65   4.17  97.84

Also peculiar how sdc and sda has twice the amount of r/s compared to the 
other drives?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
