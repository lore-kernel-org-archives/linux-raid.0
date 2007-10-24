From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Software RAID when it works and when it doesn't
Date: Wed, 24 Oct 2007 15:18:58 -0500
Message-ID: <1193257138.23414.88.camel@w100>
References: <14526.1192571833@mdt.ecitele.com>
	 <87bqaw5tqb.fsf@informatik.uni-tuebingen.de>
	 <1192777672.16416.495.camel@w100>  <471E79A5.5020607@tmr.com>
	 <1193205003.23414.72.camel@w100>  <471FA543.9090502@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471FA543.9090502@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2007-10-24 at 16:04 -0400, Bill Davidsen wrote:

> I think what you really want is to notice how long the drive and driver 
> took to recover or fail, and take action based on that. In general "kick 
> the drive" is not optimal for a few bad spots, even if the drive 
> recovery sucks.

The problem is that the driver never comes back and the whole
array hangs, waiting forever. That's why a timeout within the
md code is needed to recover from these type of drivers.

Alberto

