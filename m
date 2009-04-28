From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 10:23:42 +1200
Message-ID: <1240957422.18303.697.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	 <87ljplnmrw.fsf@frosties.localdomain>  <49F73EA2.3020803@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F73EA2.3020803@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-04-28 at 10:36 -0700, H. Peter Anvin wrote:
> Goswin von Brederlow wrote:
> > 
> > And how do you create a raid-1 partition on a whole disk raid?
> > 
> 
> What you're asking for is a partitioning layer somehow hidden away
> inside md.  This is about as intelligent as Dick Cheney.  We already
> have partitioning layers, use them.
> 
Dick Who???  

No What I'm asking for is a superblock layout that allows the boot
loader to be installed in each member disk, so that the booting from a
software raid array becomes not only possible, but reliable and easy to
set up.

-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

