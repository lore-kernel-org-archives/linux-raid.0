From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] klibc update
Date: Tue, 16 Mar 2004 21:19:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040316201917.GB2396@mars.ravnborg.org>
References: <4056B0DB.9020008@pobox.com> <20040316005229.53e08c0c.akpm@osdl.org> <20040316153719.GA13723@kroah.com> <20040316111026.6729e153.akpm@osdl.org> <40575279.7040408@pobox.com> <20040316192458.GB21172@kroah.com> <40575631.1080006@pobox.com> <20040316115340.361f2a14.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040316115340.361f2a14.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, greg@kroah.com, linux-kernel@vger.kernel.org, viro@parcelfarce.linux.theplanet.co.uk, bos@serpentine.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 16, 2004 at 11:53:40AM -0800, Andrew Morton wrote:
> Jeff Garzik <jgarzik@pobox.com> wrote:
> >
> >  >>Note that it isn't my intention to become klibc maintainer...  just in 
> >  >>case anybody started getting ideas... :)
> >  > 
> >  > 
> >  > I thought hpa was the klibc maintainer, you're just offering a patch to
> >  > add it to the build :)
> > 
> >  Right...  I meant I am not going to become the maintainer of said 
> >  patch/BK tree :)
> 
> It would be rather handy if someone could maintain the definitive tree for
> this work for a while, until we linusify it.
> 
> I don't have a feeling for its stability/readiness/desirability/anthingelse
> at this stage.  How mergeable is it?

I need to dig through the build system once more.
Last time I did it, I only managed to get it to the 'working' stage.
Not at the 'good enough' stage.

This minor issue should not delay the inclusion though - just a
note that something needs to be looked at in this area.

	Sam
