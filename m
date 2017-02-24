From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Fri, 24 Feb 2017 10:20:52 -0500
Message-ID: <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170224040816.41f2f372.ian_bruce@mail.ru>
Sender: linux-raid-owner@vger.kernel.org
To: ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/24/2017 07:08 AM, ian_bruce@mail.ru wrote:
> When assembling non-metadata arrays ("mdadm --build"), the in-kernel 
> superblock apparently defaults to the MD-RAID v0.90 type. This
> imposes a maximum of 27 component block devices, presumably as well
> as limits on device size.
> 
> mdadm does not allow you to override this default, by specifying the 
> v1.2 superblock. It is not clear whether mdadm tells the kernel to
> use the v0.90 superblock, or the kernel assumes this by itself. One
> or other of them should be fixed; there does not appear to be any
> reason why the v1.2 superblock should not be the default in this
> case.
> 
> details are here:
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=855871
> 
> This problem is easy to reproduce, even with simple hardware. You
> can use /dev/loop devices as the array components, as explained in
> the link.

Considering the existence of --build is strictly to support arrays that
predate MD raid, it seems a bit of a stretch to claim this as a bug
instead of a feature request.

When you implement this feature, you might want to consider extending
modern MD raid's support for external metadata to use RAM and then
you could do whatever you please with the array events.

See "man mdmon" for a summary of external metadata events.

Phil
