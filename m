From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: limits on raid
Date: Tue, 19 Jun 2007 16:11:11 -0400
Message-ID: <20070619201111.GQ10008@csclub.uwaterloo.ca>
References: <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com> <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm> <20070618214633.GA15468@animx.eu.org> <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: Wakko Warner <wakko@animx.eu.org>, Brendan Conoboy <blc@redhat.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 18, 2007 at 02:56:10PM -0700, david@lang.hm wrote:
> yes, I'm useing promise drive shelves, I have them configured to export 
> the 15 drives as 15 LUNs on a single ID.
> 
> I'm going to be useing this as a huge circular buffer that will just be 
> overwritten eventually 99% of the time, but once in a while I will need to 
> go back into the buffer and extract and process the data.

I would guess that if you ran 15 drives per channel on 3 different
channels, you would resync in 1/3 the time.  Well unless you end up
saturating the PCI bus instead.

hardware raid of course has an advantage there in that it doesn't have
to go across the bus to do the work (although if you put 45 drives on
one scsi channel on hardware raid, it will still be limited).

--
Len Sorensen
