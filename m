From: Al Boldi <a1426z@gawab.com>
Subject: Re: Fwd: Re: RAID performance is not too well....
Date: Mon, 9 Jul 2007 18:30:51 +0300
Message-ID: <200707091830.51707.a1426z@gawab.com>
References: <20070709113916.GA9781@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756946AbXGIPbT@vger.kernel.org>
In-Reply-To: <20070709113916.GA9781@bitwizard.nl>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rogier Wolff wrote:
> > >I have an application that creates some 228 thousand files,
> > >spread over about 4000 directories. Total is not more than
> > >1.3Gb.  (I'm not sure, and I don't care if it's 10% or 90% of
> > >that number)
> > >
> > >Anyway, I've loaded all of the 1.3Gb into the cache (the machine
> > >has 8Gb of RAM), so that only writes need to take place.
> > >
> > >After a while the machine goes into a routine of writing
> > >about 500 to 1000kbytes per second.
> > >
> > >Sync seems to take a long time:

The as-iosched has a sync bug, and if you are using that, then try deadline 
instead.


Thanks!

--
Al
