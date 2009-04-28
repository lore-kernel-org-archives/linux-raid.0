From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 23:21:11 +1200
Message-ID: <1240917671.8040.948.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	 <87ljplnmrw.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljplnmrw.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-04-28 at 11:35 +0200, Goswin von Brederlow wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > Goswin von Brederlow wrote:
> >> 
> >> Or grub2 could be thought to install itself into all MBRs of all
> >> drives in a raid set.
> >> 
> >
> > ... which is obviously completely wrong, given that that would break the
> > whole RAID layer.
> 
> Not if there is unused space for the MBR on every raid disk. The 1.2
> metadata format leaves the first 4k free on every disk.

I had considered this and figured that space the 1.2 superblock uses
would be right in the middle of your typical bootloader code, and the
space it takes up depends on how many member disks, and the size of the
write intent bitmap if it's used  (I couldn't find details of where the
write intent bitmap normally goes, so I have assumed that it goes
somewhere nearby following the superblock.)

Whats more grub would pretty much use the whole of the 1st cylinder sans
the first 512 byte MBR for the core.img, especially in the case of
starting a raid array where it needs the raid modules built into the
core image. 

-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

