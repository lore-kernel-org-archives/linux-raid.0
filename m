From: david@lang.hm
Subject: Re: limits on raid
Date: Mon, 18 Jun 2007 13:52:04 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
References: <18034.479.256870.600360@notabene.brown>
 <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
 <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown>
 <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com>
 <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4676D8DE.3050903@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brendan Conoboy <blc@redhat.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 18 Jun 2007, Brendan Conoboy wrote:

> david@lang.hm wrote:
>>  yes, sorry, ultra 320 wide.
>
> Exactly how many channels and drives?

one channel, 2 OS drives plus the 45 drives in the array.

yes I realize that there will be bottlenecks with this, the large capacity 
is to handle longer history (it's going to be a 30TB circular buffer being 
fed by a pair of OC-12 links)

it appears that my big mistake was not understanding what /proc/mdstat is 
telling me.

David Lang
