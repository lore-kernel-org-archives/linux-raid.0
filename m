From: Milan Broz <gmazyland@gmail.com>
Subject: Re: some general questions on RAID
Date: Mon, 08 Jul 2013 07:40:21 +0200
Message-ID: <51DA50C5.6080106@gmail.com>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>  <51D5F22C.70007@turmel.org>  <51D9A7CF.6000700@gmail.com>  <1373220112.5246.20.camel@fermat.scientia.net> <51D9B863.9010509@gmail.com> <1373230299.5246.175.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373230299.5246.175.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/07/2013 10:51 PM, Christoph Anton Mitterer wrote:
> On Sun, 2013-07-07 at 20:50 +0200, Milan Broz wrote:
>> For LUKS is it trivial, LVM is more complex
>> but should align to MD chunk/stripe properly as well.
> Shouldn't one get that automatically by simply setting the
> --dataalignment of the PVs to a multiple of the chunk size (or even
> better of the stripe size)... and shouldn't the default alignment
> against the 1MiB boundary (as in LUKS) work just well?

Try to not use --dataalignment explicitly.
It should be detected automatically through topology ioctl
(both for LVM and LUKS). (You can verify that itopology info
propagates correctly through stack by using lsblk -t).

Only if you know that something is wrong overwrite it
(and perhaps report bug to LVM, it should detect it properly now).

Default 1MiB alignment should work even for LVM IIRC.

IOW I am saying that for newly created array (e.g. like MD->dmcrypt->LVM)
you should get optimal alignment for performance without black magic.

(Also LVM can use MD RAID internally now but let's not complicate
already too complex device stack :)

Milan
