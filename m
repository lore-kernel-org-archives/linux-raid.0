From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 02 May 2009 00:36:34 +0200
Message-ID: <1241217394.4418.4.camel@poledra.romunt.nl>
References: <49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	 <1240957153.18303.689.camel@ezra>
	 <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com>
	 <1240963225.18303.858.camel@ezra> <49F7997C.2070808@zytor.com>
	 <1240964410.18303.895.camel@ezra> <49F79F26.9060309@zytor.com>
	 <1240965831.18303.944.camel@ezra>
	 <20090429064333.GB9372@boogie.lpds.sztaki.hu>
	 <87hc04leau.fsf@frosties.localdomain>
Reply-To: Rudy@grumpydevil.homelinux.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hc04leau.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Daniel Reurich <daniel@centurion.net.nz>, "H. Peter Anvin" <hpa@zytor.com>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op vrijdag 01-05-2009 om 23:10 uur [tijdzone +0200], schreef Goswin von
Brederlow:
> Gabor Gombas <gombasg@sztaki.hu> writes:
> 
> > On Wed, Apr 29, 2009 at 12:43:51PM +1200, Daniel Reurich wrote:
> >
> >> In which case your probably using a hardware raid controller anyway so
> >> not our problem.  Otherwise if the array is broken by a failed
> >> controller we probably shouldn't boot of it anyway.
> >
> > I have set up a box with 8 SATA disks attached to 2 on-board
> > controllers. The BIOS can boot from any of the controllers, but then it
> > can only see the disks that are attached to the selected controller.
> > Which is quite reasonable if the BIOS handles the controller selection
> > by redirecting INT 13h (I have not checked).
> >
> > With "/" on RAID1, I can boot in any failure scenarios (I've actually
> > tested that anno). With your setup, the box would never boot, since it
> > could never access enough disks in a RAID5/6 array, even if all the
> > disks/controllers are perfectly fine.
> 
> So you have lost nothing. It doesn't boot now from raid5 (accross all
> disks) and it still doesn't boot from raid5 with the proposal. Your
> hardware just doesn't support it.
> 
> >> What's specifically dangerous about it?  Define the failure modes that
> >> this scheme is unable to either cope with that it should do.
> >
> > There is no need for a failure mode. Your scheme does not work even when
> > everything is fine.
> >
> > Gabor
> 
> It would only be a problem if with the proposal things would get
> worse.
> 

It would get worse, as in many situations the installer would succeed,
and the boot would fail. Many raid 5/6 configurations will spread over
controllers, and not BIOS supports booting over several controllers. 

I really prefer the current situation, where you need to explicitly
configure a RAID1. This makes clear what is happening, and reduces
confusion. This propposal would make debug of a failed boot just so much
more difficult. 

Cheers,

Rudy

