From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Wed, 18 Jan 2012 11:08:36 +0100
Message-ID: <4F169A24.60109@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com> <1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com> <79556383A0E1384DB3A3903742AAC04A06DAEE@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A06DAEE@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "kay@redhat.com" <kay@redhat.com>, "harald@redhat.com" <harald@redhat.com>, "lpoetter@redhat.com" <lpoetter@redhat.com>, "mschmidt@redhat.com" <mschmidt@redhat.com>
List-Id: linux-raid.ids

On 01/18/12 09:13, Kwolek, Adam wrote:
> Hi,
> 
> I think that '--initrd'  option should have '--freeze-reshape' option functionality for mdadm also.
> To do this e.g.  proper variable (freeze_reshape in mdadm.c) should be set, when '--initrd' option is passed in command line.

Hi Adam,

I don't quite know what freeze_reshape does - from the name it sounds
like an option you want to set at runtime rather than when a raid is
assembled initially?

Are you proposing that we shouldn't allow reshape of an IMSM raid that
is used as the root device?

I am merely a bit confused here, so I am hoping you could clarify a bit.

Thanks,
Jes
