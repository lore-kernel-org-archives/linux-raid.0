From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: limits on raid
Date: Sun, 17 Jun 2007 09:28:09 -0400
Message-ID: <20070617132809.GB7806@animx.eu.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <20070616140857.GA4206@animx.eu.org> <Pine.LNX.4.64.0706161845180.24938@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760278AbXFQNce@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706161845180.24938@twinlark.arctic.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:
> On Sat, 16 Jun 2007, Wakko Warner wrote:
> 
> > When I've had an unclean shutdown on one of my systems (10x 50gb raid5) it's
> > always slowed the system down when booting up.  Quite significantly I must
> > say.  I wait until I can login and change the rebuild max speed to slow it
> > down while I'm using it.   But that is another thing.
> 
> i use an external write-intent bitmap on a raid1 to avoid this... you 
> could use internal bitmap but that slows down i/o too much for my tastes.  
> i also use an external xfs journal for the same reason.  2 disk raid1 for 
> root/journal/bitmap, N disk raid5 for bulk storage.  no spindles in 
> common.

I must remember this if I have to rebuild the array.  Although I'm
considering moving to a hardware raid solution when I upgrade my storage.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
