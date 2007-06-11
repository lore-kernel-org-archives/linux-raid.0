From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Paranoid read mode for raid5/6
Date: Mon, 11 Jun 2007 16:56:39 +0200 (MEST)
Message-ID: <Pine.GSO.4.64.0706111644550.9116@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi *,

Is there way to tell md to be paranoid and verify the parity for raid5/6 
on every read? I guess this would come with a (significant) performance 
hit, but sometimes that's not a big deal (unlike disks scrambling your 
data).

Also, regarding data paranoia, for check/repair of a raid6, is the effort 
made to figure out which is the misbehaving participant device, or is 
parity just blindly recalculated?

/Mattias Wadenstein
