From: David Lamparter <equinox@diac24.net>
Subject: Re: [linux-lvm] [LVM/RAID BUG DATA DESTRUCTION] 3.12.14 raid1
 initialisation + --write-mostly destroys LV
Date: Wed, 2 Apr 2014 14:15:14 +0200
Message-ID: <20140402121514.GK113782@jupiter.n2.diac24.net>
References: <20140402120320.GJ113782@jupiter.n2.diac24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140402120320.GJ113782@jupiter.n2.diac24.net>
Sender: linux-raid-owner@vger.kernel.org
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 02, 2014 at 02:03:21PM +0200, David Lamparter wrote:
> lvconvert --type raid1 -m 1 eidolon/root
> lvchange --writemostly /dev/sda4:y --writebehind 32768 eidolon/root
[...]
> The raid1 was still initialising (around 20%) when I executed the second
> command, output from /sys/block/*/stat leads me to believe the sync direction
> was inverted from the newly-added device to the existing one.
[...]
> [950580.682165] mdX: bitmap initialized from disk: read 4 pages, set 98948 of 122880 bits

A quick disk inspection with dd/hexdump indicates that garbage starts
around 19.5%, which lines up with "98948 of 122880" above.


-David
