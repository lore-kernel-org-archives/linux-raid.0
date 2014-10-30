From: Wols Lists <antlists@youngman.org.uk>
Subject: Grub2/raid quickie ...
Date: Thu, 30 Oct 2014 00:08:43 +0000
Message-ID: <5451818B.6010809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After my last shenanigans, I've now got my main system booting
successfully from a raid / partition. HOWEVER.

I'm somewhat puzzled by grub.cfg, and this is in part behind why my dev
system won't boot raid properly, I think. Grub uses two different UUIDs!?!?

One of them, (mduuid/...) is dead easy to find, "mdadm -D" gives the md
uuid of the array. But the other one, the "root=UUID=...", I'm damned if
I can find that id anywhere! Does anyone know a command, that will tell
me what that id is, so I can fix grub.cfg on my development system?

(As an aside, how do I retrospectively force a name onto an array so
that I can guarantee it will be called /dev/md100, or /dev/mdhome, or
whatever? I daren't use the /dev/mdxxx name at the moment, because they
change and the result is a system that fails to boot, or is unusable, or
some other malarkey. Dead easy for me to fix, but my wife will go spare!)

Cheers,
Wol
