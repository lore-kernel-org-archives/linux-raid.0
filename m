From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid 1 assembled but inactive - works from a "live"
 distribution...
Date: Thu, 20 Jul 2017 14:42:55 +0100
Message-ID: <5970B35F.1030007@youngman.org.uk>
References: <b9a1822b-ab01-2cb3-e417-85aafec9a3d2@yahoo.gr>
 <8504efd5-dc98-afe6-6d6c-5b1352a9c134@yahoo.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8504efd5-dc98-afe6-6d6c-5b1352a9c134@yahoo.gr>
Sender: linux-raid-owner@vger.kernel.org
To: petasisg@yahoo.gr, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/07/17 12:52, Georgios Petasis wrote:
> Another puzzling fact, is that booting fedora 25 with the previous
> kernel works.
> With the latest kernel does not.
> I tried because I saw "md: personality for level 1 is not loaded!" in
> the logs...

Has the initrd or similar been changed somehow? I'll let the experts
chime in more, but this sounds like the kernel module for raid1 has
become inaccessible.

You've got superblock v1.2, which means the old trick of booting off of
one disk read-only, before assembling the raid and switching root
read/write won't work. Therefore you

(a) *MUST* have raid1 support in grub, in order to be able to read the
mirror to find the kernel, and

(b) must have raid1 support in the kernel, so the kernel can see /.

As I say, that message makes me suspect that either the grub or the
kernel raid-1 support module has disappeared ...

Cheers,
Wol
