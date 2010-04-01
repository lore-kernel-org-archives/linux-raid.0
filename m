From: Jools Wills <jools@oxfordinspire.co.uk>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Thu, 01 Apr 2010 23:58:56 +0100
Message-ID: <1270162736.24051.0.camel@travelmate.workshop>
References: <4BB49E4D.1090809@maxeaves.co.uk> <4BB4A461.5030704@redhat.com>
	 <4BB4A89F.7030707@maxeaves.co.uk> <20100402074325.3ce34e8f@notabene.brown>
	 <20100401224644.GA2455@lazy.lzy>
Reply-To: jools@oxfordinspire.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100401224644.GA2455@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Neil Brown <neilb@suse.de>, max@maxeaves.co.uk, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Fri, 2010-04-02 at 00:46 +0200, Piergiorgio Sartor wrote:
> Hi,
> 
> > However there is real value in doing that check, at least occasionally.  It
> > catches latent read errors.
> 
> but since it is not possible to correct those errors,
> there is no point in doing it... :-)

Well it can. It can try and rewrite the block based on the data from the
other disks, and if the drive needs to, it can remap the bad block.

Best Regards

Jools

Jools Wills
-- 
IT Consultant
Oxford Inspire - http://www.oxfordinspire.co.uk - be inspired
t: 01235 519446 m: 07966 577498
jools@oxfordinspire.co.uk

