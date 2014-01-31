From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Boot fails from one of the drives cos it's not an ext4 filesystem.
Date: Thu, 30 Jan 2014 16:22:33 -0800
Message-ID: <52EAECC9.3070607@tigertech.com>
References: <52EABF3D.5060100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EABF3D.5060100@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/30/14, 1:08 PM, Richard Gomes wrote:

> This is the culprit: /dev/sdb1 is not known as ext4, as it should be.

I don't know how to affect that, but are you sure that's actually the
problem?

In my experience, a boot problem involving mirrored RAID 1 is more
likely to be a GRUB issue, needing to be fixed with something like:

# grub-install /dev/sdb

(This assumes that /dev/sdb1 really is a valid mirror of /dev/sda1; I'm
taking that on faith because you didn't include the output of "mdadm
--detail" and "mdadm --examine".)

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
