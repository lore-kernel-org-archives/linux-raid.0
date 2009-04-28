From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Mon, 27 Apr 2009 21:58:08 -0700
Message-ID: <49F68CE0.2010906@zytor.com>
References: <1240574900.4507.2076.camel@ezra> <87hc0axhg9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hc0axhg9.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> 
> Or grub2 could be thought to install itself into all MBRs of all
> drives in a raid set.
> 

... which is obviously completely wrong, given that that would break the
whole RAID layer.

The right thing is to use a RAID-1 partition.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

