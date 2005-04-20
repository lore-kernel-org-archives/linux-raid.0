From: Derek Piper <derek.piper@gmail.com>
Subject: Re: Order of kernel autodetect
Date: Wed, 20 Apr 2005 10:58:19 -0500
Message-ID: <eaa6dfe0504200858320d4c84@mail.gmail.com>
References: <200504170221.35082.systemloc@earthlink.net>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200504170221.35082.systemloc@earthlink.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You'd think something could be put in the RAID superblocks indicating
precendence. Or smarts in general of 'if a component array of the
array is not assembled, assemble it first'. Then those that just want
to boot to those kinds of RAID arrays without managing init.rd stuff
can do so.

Derek

On 4/17/05, TJ <systemloc@earthlink.net> wrote:
> I searched through the mailing list archive but I can not find this. I
> remember a discussion about trouble being caused from lack of control of the
> order that kernel autodetect chooses, and a patch to be able to control it.
> I'm running an array on top of another array right now, a RAID 5 on a linear.
> I understand the consequences of this, it's temporary. Still, the kernel
> tries to bring up the RAID 5 array before the linear, so the linear array is
> not included. If there is no way to correct this in the kernel, I need some
> help on understanding how init.rd level raid starting is supposed to work. It
> must happen very early, obviously, to ensure that auto-fsck works correctly.
> I'm guessing that it should be first, or close to first in the scripts. The
> general idea would be simply to run mdadm from a script to start the arrays,
> then?
> 
> Thanks
> TJ
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
