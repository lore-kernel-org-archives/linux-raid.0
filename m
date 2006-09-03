From: Josh Litherland <josh@temp123.org>
Subject: Re: Kernel RAID support
Date: Sun, 03 Sep 2006 00:01:54 -0400
Message-ID: <1157256114.10326.0.camel@localhost>
References: <44FA5261.4010207@sauce.co.nz>
Reply-To: josh@temp123.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FA5261.4010207@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 2006-09-03 at 15:56 +1200, Richard Scobie wrote:
> I am building  2.6.18rc5-mm1 and I cannot find the entry under "make 
> config", to enable the various RAID options.

Under "Device Drivers", switch on "Multi-device support".

-- 
Josh Litherland (josh@temp123.org)



-- 
VGER BF report: U 0.504036
