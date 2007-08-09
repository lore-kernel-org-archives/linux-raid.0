From: Neil Brown <neilb@suse.de>
Subject: Re: Major incompatibility mdadm-2.5.6 mdadm-2.6.2
Date: Thu, 9 Aug 2007 13:05:28 +1000
Message-ID: <18106.33912.192385.528908@notabene.brown>
References: <1186588439.13023.48.camel@linux0-zid>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gerald Hochegger on Wednesday August 8
Sender: linux-raid-owner@vger.kernel.org
To: Gerald Hochegger <gerald.hochegger@uni-klu.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 8, gerald.hochegger@uni-klu.ac.at wrote:
> Hello,
> 
> while manually failing devices and watching the
> resync of raid1 md devices on our SAN (IBM DS4700)
> I've encountered a weird problem:
> 

Thanks for the report.

Unfortunately I cannot duplicate this.

If you can, it would help a lot if I could see the output of 
  mdadm --examine /dev/disk/.....

for each disk after the "--add" fails with mdadm-2.6.2, and after it
succeeds with 2.5.6.

Thanks,
NeilBrown
