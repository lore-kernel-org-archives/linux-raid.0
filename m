From: Phil Turmel <philip@turmel.org>
Subject: Re: md prefered minor has been renumbered
Date: Mon, 28 Nov 2016 15:22:32 -0500
Message-ID: <7b7ed841-7fe7-627d-bdb5-edb8c7d6a894@turmel.org>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
 <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>
 <583C8D73.5060406@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <583C8D73.5060406@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, "Randall C. Grimshaw" <rgrimsha@esf.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/28/2016 03:02 PM, Wols Lists wrote:

> In My Experience (I'll probably get told I'm wrong :-) mdadm.conf seems
> to be pretty much ignored by modern systems. And md numbers now by
> default count down from 127, not up from 0.

mdadm.conf is *not* ignored.  Defaults are taken if it isn't found, or
doesn't contain the info needed.

Most modern systems have two copies of mdadm.conf.  One in the initramfs
so you can boot a root filesystem that is inside an array, and the other
in your root filesystem to assemble everything else.

Most distros copy the latter to the former when updating the initramfs.
You may have to manually trigger this operation when you are
re-arranging your arrays.

You also have to manually intervene if you want your initramfs to have
a different mdadm.conf, like a two-phase assembly.

mdadm has been counting down from 127 for as long as I've used it.

Phil
