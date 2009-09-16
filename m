From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Wed, 16 Sep 2009 15:13:33 +0200
Message-ID: <1253106813.17888.9.camel@localhost>
References: <h8nbt5$n8p$1@ger.gmane.org>
	 <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
	 <h8nfoe$n8p$3@ger.gmane.org>
	 <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	 <h8nreb$n8p$4@ger.gmane.org>  <87ws3z5iro.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ws3z5iro.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2009-09-16 at 11:41 +0200, Goswin von Brederlow wrote:
> Alternatively write a re-map device-mapper target that reserves some
> space of the disk and remaps bad blocks itself.
> 
That'd require some place to store the mapping so that the whole thing
still works after a reboot. Which should probably be on a different
disk. 

I tend to want to move (part of) that problem to userspace; you may want
to do more than a simple remapping of a few blocks when that happens
(e.g. test-reading the surrounding area).

