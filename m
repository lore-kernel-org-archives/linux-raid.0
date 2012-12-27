From: Phil Turmel <philip@turmel.org>
Subject: Re: md: kicking non-fresh sdf3 from array!
Date: Thu, 27 Dec 2012 14:57:13 -0500
Message-ID: <50DCA819.80809@turmel.org>
References: <CAK2H+effDWFWP32wO4vXPSQ16tgZKdBwvQRRiq+Qpy03VCE6xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+effDWFWP32wO4vXPSQ16tgZKdBwvQRRiq+Qpy03VCE6xA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

On 12/27/2012 01:48 PM, Mark Knecht wrote:

[trim /]

> I'd like to check that the following commands would be the recommended
> way to get the RAID6 back into a good state.
> 
> /sbin/mdadm /dev/md3 --fail /dev/sdf3 --remove /dev/sdf3

Shouldn't need the above, /dev/sdf3 isn't in the array.

> /sbin/mdadm /dev/md3 --add /dev/sdf3

mdadm may whine about the superblock, but should let you proceed.  But
yes, this is correct.

If you had a bitmap on the array, you would have been able to --re-add
without a full rebuild.  (On newer versions of mdadm, --add implies
--re-add if all the conditions are met.)

Phil
