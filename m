From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6 now in 2.6.1-mm
Date: Mon, 19 Jan 2004 11:04:04 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400C2A24.1010304@zytor.com>
References: <200401191848.i0JImOi01560@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401191848.i0JImOi01560@dns1.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Can anyone explain how RAID6 works?  I understand RAID5, XOR, but I don't
> see how that could be extended to allow any 2 disks to fail.
> 

If you want the gory details, I've written a short paper on it:

http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

	-hpa

