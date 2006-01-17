From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 15:10:19 +0100
Message-ID: <20060117141019.GA32232@uio.no>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932505AbWAQOK0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43CCA80B.4020603@tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 17, 2006 at 11:17:15AM +0300, Michael Tokarev wrote:
> Neil, is this online resizing/reshaping really needed?  I understand
> all those words means alot for marketing persons - zero downtime,
> online resizing etc, but it is much safer and easier to do that stuff
> 'offline', on an inactive array, like raidreconf does - safer, easier,
> faster, and one have more possibilities for more complex changes. 

Try the scenario where the resize takes a week, and you don't have enough
spare disks to move it onto another server -- besides, that would take
several days alone... This is the kind of use-case for which I wrote the
original patch, and I'm grateful that Neil has picked it up again so we can
finally get something working in.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
