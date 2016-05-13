From: Phil Turmel <philip@turmel.org>
Subject: Re: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Fri, 13 May 2016 10:04:53 -0400
Message-ID: <5735DF05.8080706@turmel.org>
References: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
 <5734D23D.6030400@turmel.org>
 <f06998d6-8e1e-c8ea-a22c-1307935092c3@misalpina.net>
 <5734E637.6030307@turmel.org>
 <7cf56631-7909-6a92-f0b2-05dd02722ee8@misalpina.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7cf56631-7909-6a92-f0b2-05dd02722ee8@misalpina.net>
Sender: linux-raid-owner@vger.kernel.org
To: Claudiu Rad <jazzman@misalpina.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/12/2016 05:37 PM, Claudiu Rad wrote:

> how can i safely stop this reshape and assuming my / partition inside
> the array is sane enough restart the actual server normally after
> fsck-ing all volumes?

Well, your root is inside the array.  So you won't be able to boot
without the array assembling in the initramfs, which needs manual
intervention to supply the backup file.

If your hosting service provides access to the boot console, you could
do this with "rd.shell" or whatever kernel option tells your initramfs
to drop into a rescue console.  Then you could manually assemble and
resume booting.  This would be true even if you had properly specified a
backup file outside the array.

I suspect this was one of the motivations for the enhancement to modern
mdadm & kernels to avoid the backup file for many cases by manipulating
the data offset.  Such a reshape in progress can be automatically
assembled without special options during boot.  Plus it is faster -- one
third fewer I/O operations.

Phil
