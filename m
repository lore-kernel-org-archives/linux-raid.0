From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 19:06:43 +0200
Message-ID: <62b0912f0607101006k6f9e66cfp86d4f0d0c1de4a3a@mail.gmail.com>
References: <loom.20060709T205013-455@post.gmane.org>
	 <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
	 <loom.20060710T095111-275@post.gmane.org>
	 <44B213CD.5010907@idgmail.se>
	 <loom.20060710T112944-980@post.gmane.org>
	 <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>
	 <loom.20060710T132722-427@post.gmane.org>
	 <62b0912f0607100507s21544d12xec9a8bf117b6edc2@mail.gmail.com>
	 <loom.20060710T142912-798@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20060710T142912-798@post.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Karl Voit <news@karl-voit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Karl Voit wrote:
> Before that, I'd like to check again now with
> the latest kernel and the latest mdadm:
>
> # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> mdadm: No suitable drives found for /dev/md0
> [ ... snip: same message with --run and --force ... ]

No idea what that means, sorry.
Check the MDADM source code, as far as I remember it's well commented.

> root@ned ~ # mdadm --zero-superblock /dev/sda
> mdadm: Unrecognised md component device - /dev/sda

Ack?
No clue, sorry.  Perhaps you've already zeroed that superblock?

Check the source for the meaning of the message.
Or try to get hold of our local target of godly worship, NeilB ;-).

> OK, those are other (newer) messages. Do they change anything or
> should I try the commands above now?

Depends how careful you are.
Personally, I'd probably try and find out why the above commands fail,
just in case there's something wrong with your new kernel or mdadm.
