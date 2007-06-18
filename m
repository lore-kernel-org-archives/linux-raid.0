From: Brendan Conoboy <blc@redhat.com>
Subject: Re: limits on raid
Date: Mon, 18 Jun 2007 11:20:02 -0600
Message-ID: <4676BEC2.7090809@redhat.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> in my case it takes 2+ days to resync the array before I can do any 
> performance testing with it. for some reason it's only doing the rebuild 
> at ~5M/sec (even though I've increased the min and max rebuild speeds 
> and a dd to the array seems to be ~44M/sec, even during the rebuild)

With performance like that, it sounds like you're saturating a bus 
somewhere along the line.  If you're using scsi, for instance, it's very 
easy for a long chain of drives to overwhelm a channel.  You might also 
want to consider some other RAID layouts like 1+0 or 5+0 depending upon 
your space vs. reliability needs.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
