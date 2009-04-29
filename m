From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 12:43:51 +1200
Message-ID: <1240965831.18303.944.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain>	<49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	 <1240957153.18303.689.camel@ezra>
	 <18935.35747.471257.202356@notabene.brown>  <49F78F26.2040909@zytor.com>
	 <1240963225.18303.858.camel@ezra>  <49F7997C.2070808@zytor.com>
	 <1240964410.18303.895.camel@ezra>  <49F79F26.9060309@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F79F26.9060309@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-04-28 at 17:28 -0700, H. Peter Anvin wrote:
> Daniel Reurich wrote:
> >>>  
> >> Grub is capable of doing that IF THE FIRMWARE CAN REACH IT.
> > 
> > Well if the firmware can't find one if the disks, then it doesn't matter
> > what scheme we have.  Even a single disk won't work.
> 
> It is *quite* common that firmware can reach a subset of the disks.  If
> not when the system is set up, then when a controller is blown and the
> user has to install a new one.  I have seen this particular malfunction
> up close more times than I can count.
> 
In which case your probably using a hardware raid controller anyway so
not our problem.  Otherwise if the array is broken by a failed
controller we probably shouldn't boot of it anyway.

> > What's your beef. MD already reserve some space for the superblock, and
> > write-intent bitmap (which I believe is also replicated across the
> > member disks), so why not add some space to this to make it possible for
> > a bootloader as well.
> 
> My beef is that you're actively promoting an extremely dangerous
> concept, dangerous exactly because it is seductive -- "it seems so
> easy."  Most users, you included, apparently, typically will have no
> notion of the failure modes, and will pick the "easy" option.
> 
What's specifically dangerous about it?  Define the failure modes that
this scheme is unable to either cope with that it should do.

> Booting is ugly business.  I have dealt with the subtleties for almost
> two decades, and it riles me when people go and foist off bad ideas on
> users.

Then stop being so emotive about it and explain the failings of the
scheme rather than point the finger at me and say I don't know.

-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

