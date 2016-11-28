From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: md prefered minor has been renumbered
Date: Mon, 28 Nov 2016 20:39:17 +0000
Message-ID: <583C95F5.9000701@youngman.org.uk>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
 <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>
 <583C8D73.5060406@youngman.org.uk>
 <7b7ed841-7fe7-627d-bdb5-edb8c7d6a894@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b7ed841-7fe7-627d-bdb5-edb8c7d6a894@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/11/16 20:22, Phil Turmel wrote:
> On 11/28/2016 03:02 PM, Wols Lists wrote:
> 
>> In My Experience (I'll probably get told I'm wrong :-) mdadm.conf seems
>> to be pretty much ignored by modern systems. And md numbers now by
>> default count down from 127, not up from 0.
> 
> mdadm.conf is *not* ignored.  Defaults are taken if it isn't found, or
> doesn't contain the info needed.

I did say IME :-)
> 
> Most modern systems have two copies of mdadm.conf.  One in the initramfs
> so you can boot a root filesystem that is inside an array, and the other
> in your root filesystem to assemble everything else.

Mine don't appear to have any ... and when I've tried to create one, it
was ignored. Of course, that doesn't rule out incompetence on my part
:-) But it means the defaults are perfectly okay for me :-) and probably
most people most of the time ...
> 
> Most distros copy the latter to the former when updating the initramfs.
> You may have to manually trigger this operation when you are
> re-arranging your arrays.
> 
> You also have to manually intervene if you want your initramfs to have
> a different mdadm.conf, like a two-phase assembly.
> 
> mdadm has been counting down from 127 for as long as I've used it.

I think I created several of my arrays as md0/1/2. And they stayed that
way for a little while before deciding to renumber.
> 
> Phil
> 
Cheers,
Wol
