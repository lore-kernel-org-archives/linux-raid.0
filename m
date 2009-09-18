From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Fri, 18 Sep 2009 11:35:38 +0000
Message-ID: <1253273738.9662.636.camel@kiste>
References: <h8nbt5$n8p$1@ger.gmane.org>
	 <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
	 <h8nfoe$n8p$3@ger.gmane.org>
	 <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	 <h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain>
	 <1253106813.17888.9.camel@localhost>
	 <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2009-09-18 at 11:17 +0300, Majed B. wrote:
> 
> I have a RAID5 array of 8 disks running degraded on 7. One of the 7
> has bad sectors and the one that is not in the array also had bad
> sectors.

If you run a check on a degraded array and the check runs into errors it
can't recover from, I assume that the disk will get kicked off and
you'll have a nonfunctional array instead.

Not something I'd do in your situation.

I'll try to finish my patch ASAP.

It should be possible to convince the code to read from the offline disk
when absolutely necessary, but no guarantee that I'll get that in right
away. (On second thought, this only matters for RAID6.)

