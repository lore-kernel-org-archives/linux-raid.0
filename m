From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Grub2/raid quickie ...
Date: Wed, 29 Oct 2014 19:21:57 -0600
Message-ID: <AE473A7D-9627-48EF-B435-1FF287BD156C@colorremedies.com>
References: <5451818B.6010809@youngman.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5451818B.6010809@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Oct 29, 2014, at 6:08 PM, Wols Lists <antlists@youngman.org.uk> wrote:

> But the other one, the "root=UUID=...", I'm damned if
> I can find that id anywhere! Does anyone know a command, that will tell
> me what that id is, so I can fix grub.cfg on my development system?

blkid

The UUID being referenced by grub-mkconfig is the first UUID reported by blkid, which is the filesystem volume UUID. It's not the same thing as the partition UUID found on GPT disks (a.k.a. unique partition GUID).


> 
> (As an aside, how do I retrospectively force a name onto an array so
> that I can guarantee it will be called /dev/md100, or /dev/mdhome, or
> whatever? I daren't use the /dev/mdxxx name at the moment, because they
> change and the result is a system that fails to boot, or is unusable, or
> some other malarkey. Dead easy for me to fix, but my wife will go spare!)

Pretty sure that goes in mdadm.conf and then you need to rebuild the initramfs since that mdadm.conf gets pulled in and referenced during early boot. Or I'm 100% wrong, and hopefully someone else says what's correct.


Chris Murphy