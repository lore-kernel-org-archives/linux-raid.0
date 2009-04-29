From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 12:02:33 +1200
Message-ID: <1240963353.18303.862.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	 <87ljplnmrw.fsf@frosties.localdomain>  <49F73EA2.3020803@zytor.com>
	 <1240957422.18303.697.camel@ezra>  <49F791B2.3010009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F791B2.3010009@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > No What I'm asking for is a superblock layout that allows the boot
> > loader to be installed in each member disk, so that the booting from a
> > software raid array becomes not only possible, but reliable and easy to
> > set up.
> > 
> 
> What you're asking for is a partitioning scheme hidden away in md.
> 
Nope, just the first 64K of each member disk to be reserved for a raid
aware bootloader.

-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

