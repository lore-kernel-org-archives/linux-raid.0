From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Fri, 20 Jan 2012 15:05:30 +0100
Message-ID: <4F1974AA.4050801@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com> <1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com> <79556383A0E1384DB3A3903742AAC04A06DAEE@IRSMSX101.ger.corp.intel.com> <4F169A24.60109@redhat.com> <79556383A0E1384DB3A3903742AAC04A06F09D@IRSMSX101.ger.corp.intel.com> <4F16F6C9.1050108@redhat.com> <4F16F77C.6000405@redhat.com> <79556383A0E1384DB3A3903742AAC04A06F48F@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A06F48F@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "kay@redhat.com" <kay@redhat.com>, "harald@redhat.com" <harald@redhat.com>, "lpoetter@redhat.com" <lpoetter@redhat.com>, "mschmidt@redhat.com" <mschmidt@redhat.com>
List-Id: linux-raid.ids

On 01/19/12 08:25, Kwolek, Adam wrote:
>>> If there is already a --freeze-reshape option, then I think it is
>>> > > better to have the boot scripts set that explicitly. The initramfs
>>> > > stage isn't really something we expect users or admins to mess with
>>> > > manually, so it ought to work for that. However if there is no option
>>> > > for this, and I just need to set the variable when detecting --initrd,
>>> > > then I can add that to the patchset no problem.
>> > 
>> > I guess I should add here, that I am not strongly opposed to setting
>> > freeze_reshape for initrd. I am just wary of setting multiple flags magically
>> > without it being obvious to the user/admin.
>> > 
>> > Cheers,
>> > Jes
> Up to you.

Ok, I will leave it up to Neil/Kay/Harald - what do you guys think?
Should we make --initrd set the freeze_reshape flag, or better to expect
the initramfs scripts to specify it directly?

Cheers,
Jes

