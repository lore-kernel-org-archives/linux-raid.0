From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Mon, 31 Jul 2017 21:35:33 +0100
Message-ID: <597F9495.9060507@youngman.org.uk>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
 <20170605092454.GA3651@metamorpher.de>
 <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
 <20170605235619.GA8478@metamorpher.de>
 <5f9ed8be-ec90-17bc-3e45-0721689a62a8@tonel.li>
 <20170610204105.GA19409@metamorpher.de>
 <e0c059b0-2d68-92bf-3eb9-e2827602061c@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e0c059b0-2d68-92bf-3eb9-e2827602061c@tonel.li>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Tonelli <paul@tonel.li>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/07/17 20:57, Paul Tonelli wrote:
> but a reboot always brings me back to step 2), with the need to press
> ctrl-D at boot time.
> 
> What am I missing? Am I using a bad version of the mdadm or kernel
> (mdadm:amd64 3.3.2-5+deb8u2, kernel 4.8.0-0.bpo.2-amd64) or am I doing
> it wrong in another way ?

Okay. Step 2. Does an "mdadm --assemble --scan" work instead? This will
tell us whether your raid array is fine, just that it's not being
properly assembled at boot. Actually, before you do that, try a "mdadm
/dev/md0 --stop".

If the stop then assemble scan works, it tells us that your boot
sequence is at fault, not the array.

Can you post the relevant section of grub.cfg? That might not be
assembling the arrays.

Cheers,
Wol
