From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: limits on raid
Date: Tue, 19 Jun 2007 11:07:54 -0400
Message-ID: <4677F14A.5060909@cfl.rr.com>
References: <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758933AbXFSPH6@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Brendan Conoboy <blc@redhat.com>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> one channel, 2 OS drives plus the 45 drives in the array.

Huh?  You can only have 16 devices on a scsi bus, counting the host 
adapter.  And I don't think you can even manage that much reliably with 
the newer higher speed versions, at least not without some very special 
cables.

> yes I realize that there will be bottlenecks with this, the large 
> capacity is to handle longer history (it's going to be a 30TB circular 
> buffer being fed by a pair of OC-12 links)

Building one of those nice packet sniffers for the NSA to install on 
AT&Ts network eh? ;)
