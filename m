From: Michael Alger <linux-raid@mm.quex.org>
Subject: Re: Updating superblock to reflect new disc locations
Date: Thu, 12 Jan 2006 12:31:01 +0800
Message-ID: <43C5DB85.50808@mm.quex.org>
References: <43C495BA.9070502@mm.quex.org> <17349.50814.993086.189022@cse.unsw.edu.au> <Pine.LNX.4.63.0601111942110.1824@twinlark.arctic.org>
Reply-To: linux-raid@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0601111942110.1824@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Many thanks to you both - I should have thought to check the initrd.

I rebuilt it (mkinitrd -o /boot/initrd.img-<version> for Debian) and 
that worked, then after I saw Dean's email I let dpkg-reconfigure 
rebuild the initrd, to be sure it would work after the next kernel 
upgrade. All peachy.

Thanks again.

