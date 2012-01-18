From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Wed, 18 Jan 2012 17:43:53 +0100
Message-ID: <4F16F6C9.1050108@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com> <1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com> <79556383A0E1384DB3A3903742AAC04A06DAEE@IRSMSX101.ger.corp.intel.com> <4F169A24.60109@redhat.com> <79556383A0E1384DB3A3903742AAC04A06F09D@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A06F09D@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "kay@redhat.com" <kay@redhat.com>, "harald@redhat.com" <harald@redhat.com>, "lpoetter@redhat.com" <lpoetter@redhat.com>, "mschmidt@redhat.com" <mschmidt@redhat.com>
List-Id: linux-raid.ids

On 01/18/12 11:36, Kwolek, Adam wrote:
> 
> 
>> -----Original Message-----
>> From: Jes Sorensen [mailto:Jes.Sorensen@redhat.com]
>> Sent: Wednesday, January 18, 2012 11:09 AM
>> To: Kwolek, Adam
>> Cc: neilb@suse.de; linux-raid@vger.kernel.org; dledford@redhat.com;
>> kay@redhat.com; harald@redhat.com; lpoetter@redhat.com;
>> mschmidt@redhat.com
>> Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
>>
>> On 01/18/12 09:13, Kwolek, Adam wrote:
>>> Hi,
>>>
>>> I think that '--initrd'  option should have '--freeze-reshape' option
>> functionality for mdadm also.
>>> To do this e.g.  proper variable (freeze_reshape in mdadm.c) should be set,
>> when '--initrd' option is passed in command line.
>>
>> Hi Adam,
>>
>> I don't quite know what freeze_reshape does - from the name it sounds like
>> an option you want to set at runtime rather than when a raid is assembled
>> initially?
> 
> Yes, it is intended to be specified for assembly during initrd
> phase. It "tells" to 'grow continue' to restore array critical
> section only. It stops reshape at this moment to keep process
> safe during file system pivot when mdadm loosing fs context.
> Reshape should be continued later by invoking mdadm grow with
> '--continue' option.

Is there already a --freeze-reshape option implemented? I didn't see any
in the man page or the help output on my system here.

>> Are you proposing that we shouldn't allow reshape of an IMSM raid that is
>> used as the root device?
> 
> We should tell to mdadm for boot device assembly to be prepared for
> fs pivot when reshape is in progress. We can do this by specifying 2
> options in command line, but in real world "someone will forget about
> something", so I think '--iinitrd' can have '--freeze-reshape'
> functionality also /without freeze-reshape option removal for
> separate use when raid will not be a boot device/. As I wrote before
> it needs to set one variable during command line parsing in mdadm.c
> only.

If there is already a --freeze-reshape option, then I think it is better
to have the boot scripts set that explicitly. The initramfs stage isn't
really something we expect users or admins to mess with manually, so it
ought to work for that. However if there is no option for this, and I
just need to set the variable when detecting --initrd, then I can add
that to the patchset no problem.

Cheers,
Jes
