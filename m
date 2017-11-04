From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid5-cache: Cannot get enough stripes due to memory pressure.
 Recovery failed.
Date: Sat, 4 Nov 2017 17:54:06 +0000
Message-ID: <59FDFEBE.3000904@youngman.org.uk>
References: <e4b20202-95e8-c31c-c37b-3da3109537d2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e4b20202-95e8-c31c-c37b-3da3109537d2@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/17 16:13, Larkin Lowrey wrote:
> The prior shutdown could have been unclean for the array. The shutdown
> process got stuck and I eventually had to use the reset button.
> 
> I have a second (8 drive) raid6 array on this host that has a 2GB
> journal and it won't assemble either.
> 
> Kernel: 4.13.10-100.fc25.x86_64
> 
> What can I do? Do I need more RAM?

You're in the recovery shell ... does/can that use all available ram?
(Like DOS needed special drivers to use ram above 1MB). So I doubt you
need more ram.

Get a rescue disk of some sort, boot into that, so you've got a full
working linux off DVD/CD, and see if you can assemble the arrays from there.

Cheers,
Wol
