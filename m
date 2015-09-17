From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: Fwd: mdadm: not rebuilding IMSM array without OROM
Date: Thu, 17 Sep 2015 10:43:29 +0200
Message-ID: <55FA7D31.5030006@intel.com>
References: <CAMrEMU_LmmB-fmLkW1g6ptYnM-qbXNBJL58NR0Ok8Ecx_16KRA@mail.gmail.com>
 <CAMrEMU_du7HKa5x9dNpiBkp103-9NtF0fXD+Bv-Y6o41tEM85A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMrEMU_du7HKa5x9dNpiBkp103-9NtF0fXD+Bv-Y6o41tEM85A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Capella <justincapella@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/16/2015 07:54 PM, Justin Capella wrote:
> In reference to the following commit:
> http://git.neil.brown.name/?p=mdadm.git;a=commit;h=7eee461e91df702d8f588955b03e5bbb07e1f88d
> 
> I am unclear how to proceed given my unfortunate environment, where I
> have replaced the motherboard. I am fearful of reconfiguring the raid
> in OROM in case it causes data loss. Is anyone aware of a tool to
> rebuild/configure the OROM settings from the autodetected ones?
> 
> Should I just modify my startup scripts in my initrd by hand to include --force?

You can use IMSM_NO_PLATFORM environment variable (see man mdadm), but if
your new motherboard also supports IMSM, then you can just enable it.
The raid will be detected normally and this should not cause data loss.

Artur
