From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 2/4] Add --initrd argument to mdadm
Date: Thu, 19 Jan 2012 07:25:08 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A06F48F@IRSMSX101.ger.corp.intel.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
 <1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>
 <79556383A0E1384DB3A3903742AAC04A06DAEE@IRSMSX101.ger.corp.intel.com>
 <4F169A24.60109@redhat.com>
 <79556383A0E1384DB3A3903742AAC04A06F09D@IRSMSX101.ger.corp.intel.com>
 <4F16F6C9.1050108@redhat.com> <4F16F77C.6000405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F16F77C.6000405@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "kay@redhat.com" <kay@redhat.com>, "harald@redhat.com" <harald@redhat.com>, "lpoetter@redhat.com" <lpoetter@redhat.com>, "mschmidt@redhat.com" <mschmidt@redhat.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Jes Sorensen [mailto:Jes.Sorensen@redhat.com]
> Sent: Wednesday, January 18, 2012 5:47 PM
> To: Kwolek, Adam
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; dledford@redhat.com;
> kay@redhat.com; harald@redhat.com; lpoetter@redhat.com;
> mschmidt@redhat.com
> Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
> 
> On 01/18/12 17:43, Jes Sorensen wrote:
> >> We should tell to mdadm for boot device assembly to be prepared for
> >> > fs pivot when reshape is in progress. We can do this by specifying
> >> > 2 options in command line, but in real world "someone will forget
> >> > about something", so I think '--iinitrd' can have '--freeze-reshape'
> >> > functionality also /without freeze-reshape option removal for
> >> > separate use when raid will not be a boot device/. As I wrote
> >> > before it needs to set one variable during command line parsing in
> >> > mdadm.c only.
> > If there is already a --freeze-reshape option, then I think it is
> > better to have the boot scripts set that explicitly. The initramfs
> > stage isn't really something we expect users or admins to mess with
> > manually, so it ought to work for that. However if there is no option
> > for this, and I just need to set the variable when detecting --initrd,
> > then I can add that to the patchset no problem.
> 
> I guess I should add here, that I am not strongly opposed to setting
> freeze_reshape for initrd. I am just wary of setting multiple flags magically
> without it being obvious to the user/admin.
> 
> Cheers,
> Jes

Up to you.

BR
Adam
