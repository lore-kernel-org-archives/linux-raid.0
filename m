From: antlists <antlists@youngman.org.uk>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 22:55:12 +0100
Message-ID: <a9576863-cfce-1c08-078b-ca945bb8b551@youngman.org.uk>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
 <5ECC1488.3010804@youngman.org.uk>
 <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
 <5ECC1A86.3010104@youngman.org.uk>
 <24268.15511.752645.491837@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24268.15511.752645.491837@quad.stoffel.home>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Thomas Grawert <thomasgrawert0282@gmail.com>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

On 25/05/2020 22:45, John Stoffel wrote:
> This is Debian Buster, and it's he's upto date with debian packages,
> he's almost certainly in a stable setup.  Now maybe we need to talk
> with the Debian package maintainer for mdadm and ask them to upgrade,
> or maybe why they haven't updated recently.

If you're going to do that, I think you need to get the kernel 
maintainer to upgrade that as well...

As I see it, the CAUSE of the problem is that we have an old-but-updated 
frankenkernel. It doesn't matter whether mdadm is contemporary with the 
original pre-franken-state kernel or contemporary with the new 
up-to-date frankenkernel, the fact of the matter is that the 
relationship between mdadm and the kernel isn't regression tested beyond 
making sure that arrays assemble and run correctly.

Hence the inevitable screw-ups when users try to administer their arrays.

Cheers,
Wol
