From: Chris <email.bug@arcor.de>
Subject: Re: Last working drive in RAID1
Date: Thu, 5 Mar 2015 22:54:36 +0100
Message-ID: <20150305225436.1bb4d88a@smtp.arcor.de>
References: <54F7633F.3020503@gmail.com>
	<20150305084634.2d590fe4@notabene.brown>
	<54F78BD9.403@gmail.com>
	<20150305102622.016ec792@notabene.brown>
	<54F87C7C.8020501@youngman.org.uk>
	<54F8B5D2.8070304@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F8B5D2.8070304@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Thu, 05 Mar 2015 15:00:18 -0500
schrieb Phil Turmel <philip@turmel.org>:

> It has to stay there to give errors to the upper layers that are still
> hooked to it.  When they are administratively "unhooked", aka
> unmounted or disassociated with mdadm --remove.
> 
> Or, quite possibly, the device is plugged back in, at which point the
> device name is there for it (as long as you use the same port, of
> course).  In which case the filesystem may very well resume
> successfully.

From reading this it makes sense that the md device stays there, just
as the the physical device nodes. (to give errors, and to recover)

However, as I understood this thread, md does not seem to inform upper
layers or the user (even not through its own --monitor?) properly.
To me, marking the last disk within an array as failed (*within* the
array) just seems to make more sense, so /proc/mdstat actually
iforms about the md error state (and the md device returning errors on
access).

Regards,
Chris
