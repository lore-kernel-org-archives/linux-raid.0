From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 17:01:55 -0700
Message-ID: <49F798F3.9090804@zytor.com>
References: <1240574900.4507.2076.camel@ezra>	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>	 <1240957153.18303.689.camel@ezra>	 <18935.35747.471257.202356@notabene.brown> <1240962119.18303.826.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240962119.18303.826.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Reurich wrote:
> 
> That would be nice.  The 1.1 superblock is no good as the bootsector
> goes in the same place, and 1.2 is where I expect grub would be writing
> data too.  I'll check this though.  Grub still needs patching to
> understand v1.X superblocks, so that could include blacklisting the
> location of a v1.2 superblock location and some for the write-intent
> bitmap. (Is there a way to determine where the w-i bitmap gets located
> and how big it is from the super block.)
> 
> I'd say put lets reserve the first 64K (2 cylinders) for boot and
> superblock.
> 

I say let's tell people to do the only sane thing and carve out an
appropriate chunk using existing partitioning methods.

Anything else is reinventing the wheel, badly, at the wrong level.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

