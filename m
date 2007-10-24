From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Software RAID when it works and when it doesn't
Date: Wed, 24 Oct 2007 00:50:03 -0500
Message-ID: <1193205003.23414.72.camel@w100>
References: <14526.1192571833@mdt.ecitele.com>
	 <87bqaw5tqb.fsf@informatik.uni-tuebingen.de>
	 <1192777672.16416.495.camel@w100>  <471E79A5.5020607@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471E79A5.5020607@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2007-10-23 at 18:45 -0400, Bill Davidsen wrote:

> I'm not sure the timeouts are the problem, even if md did its own 
> timeout, it then needs a way to tell the driver (or device) to stop 
> retrying. I don't believe that's available, certainly not everywhere, 
> and anything other than everywhere would turn the md code into a nest of 
> exceptions.
> 

If we loose the ability to communication to that drive I don't see it
as a problem (that's the whole point, we kick it out of the array). So,
if we can't tell the driver about the failure we are still OK, md could
successfully deal with misbehaved drivers.

Alberto


