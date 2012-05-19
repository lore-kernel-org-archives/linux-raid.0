From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Creating a 3-disk RAID6 array
Date: Fri, 18 May 2012 17:04:52 -0700
Message-ID: <4FB6E3A4.3020103@zytor.com>
References: <4FB4534A.5070608@volatilevoid.net> <20120517113817.7faf9c1e@notabene.brown> <4FB4FAA9.7000100@hesbynett.no> <4FB50573.6020604@anonymous.org.uk> <4FB5FAA7.4090401@zytor.com> <20120518175700.61337765@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120518175700.61337765@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, David Brown <david.brown@hesbynett.no>, Oliver Martin <oliver@volatilevoid.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/18/2012 12:57 AM, NeilBrown wrote:
> 
> Possibly we could special case the parity-generation code to just
> copy the data block when data-disks==1.  That sound easy enough... 
> But the raid456 module needs to understand this 
> 3-way-RAID1-pretending-to-be-RAID6, we cannot use the raid1 module
> to do it.
> 

I actually think it will Just Work as-is... there might be some need
to modify the loop control logic.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

