From: Brendan Conoboy <blc@redhat.com>
Subject: Re: limits on raid
Date: Mon, 18 Jun 2007 16:00:49 -0600
Message-ID: <46770091.2080109@redhat.com>
References: <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com> <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm> <20070618214633.GA15468@animx.eu.org> <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706181453090.14890@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: Wakko Warner <wakko@animx.eu.org>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> yes, I'm useing promise drive shelves, I have them configured to export 
> the 15 drives as 15 LUNs on a single ID.

Well, that would account for it.  Your bus is very, very saturated.  If 
all your drives are active, you can't get more than ~7MB/s per disk 
under perfect conditions.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
