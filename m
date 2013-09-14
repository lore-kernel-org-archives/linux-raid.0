From: Martin Wilck <mwilck@arcor.de>
Subject: Re: "detect reshape on array start" (was Re: Weirdness with DDF arrays
 (mdadm 3.3))
Date: Sat, 14 Sep 2013 23:16:17 +0200
Message-ID: <5234D221.8010607@arcor.de>
References: <CAC9WiBgJX4VH7-cNMVcqPL-9UpsH03Z7cRKvLUOSUogkiQpx7Q@mail.gmail.com> <52346FB1.2020205@arcor.de> <5234CEAB.1090808@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5234CEAB.1090808@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: adam.kwolek@intel.com
List-Id: linux-raid.ids

On 09/14/2013 11:01 PM, Martin Wilck wrote:

> it seems that has been made for is a pretty special case (reshape of
> RAID0 to RAID4, or would that affect other target geometries as well?)
> 
> For experimenting, I reverted the patch and ran some of the IMSM test
> cases for reshape of RAID0 to something else, and they all still succeed.

Meanwhile I ran all test cases for IMSM (09, 11-18) with this patch
reverted; they all succeed.

Martin
