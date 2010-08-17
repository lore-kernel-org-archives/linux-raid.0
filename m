From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Tue, 17 Aug 2010 09:49:01 -0700
Message-ID: <4C6ABD7D.7050909@intel.com>
References: <4C69D525.4060404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C69D525.4060404@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "K. Posern" <quickhelp@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dave.jiang@intel.com
List-Id: linux-raid.ids

[ added linux-raid with permission ]

On 8/16/2010 5:17 PM, K. Posern wrote:
> Dear Mr. Williams,
>
> I am a bit desperate that's why I dare to contact you like this:
> As I did not find any answer to my below 2 questions in man-pages, in
> the source-code (quick look with grep+less), on irc channels and of
> course with google, I am hoping that you can give me any hint or refer
> me to somebody who might.
>
> I adore Intels engagement for linux. Unfortunately is there no website
> (yet?): "intellinuxraid.org" (like there is: intellinuxgraphics.org).

There is no website.  My personal thought is that we should extend the 
content at raid.wiki.kernel.org.

> The only official information from intel I could dig up so fare states:
> imsm is supported with mdadm >=v3 and dmraid >=v1
>
> But I am trying to find out if it is possible to:
>
> a) Autoassemble the RAID (so avoid having an initrd)

No, the auto-assemble I mentioned in the pull request will not avoid 
having an initrd.  You are thinking of "in-kernel autodetect" which is 
not supported with the imsm metadata format (or any metadata format 
besides the md-v0.90 format).  In general assembling arrays in userspace 
is much more flexible which is why you see the in-kernel autodetect code 
has been put in a no-new-features/maintenance-only mode.

I know Fedora and OpenSUSE have added support for this configuration to 
their initrd tools.

> b) BOOT linux from this: grub2? lilo? ... anything?

One of the primary benefits of using the Intel(R) RST (mdadm-imsm) 
format is that you can use the platform bios option-rom to boot from 
raid.  So grub, grub2, lilo, or any other bootloader can boot from raid. 
  This is because the option-rom installs a bios int13 handler that 
allows the bootloader to read from a raid volume as if it were a 
standalone disk.

> About (a):
> The git pull request seems to indicate thate there is auto-assembly
> support for imsm software raids?!
> Is this true? - again: grep

The "mdadm -As" command will search all available disks and 
automatically assemble all the imsm arrays that it finds.

> What RAID-Levels (for an imsm fakeraid) are supported?

I think the 'fakeraid' moniker is tired and misplaced when referring to 
this new functionality in md/mdadm.  There is nothing fake about Linux 
software RAID.  I prefer "bios-raid" or even "software raid".

Current platforms ship support for raid levels 0, 1, 10, and 5.

> Especially: What about RAID-0?

Supported.

>
> About (b):
> According to "Kyron" and his wiki:
> http://wiki.neuralbs.com/index.php/Gentoo_Quick_Install_notes#GRUB2
> grub2 should support imsm (but grep for imsm in the Bazaar checkout does
> not yield any hit) <<< I contacted the grub2 mailing-list for clarification

Like I mentioned above, the bootloader does not need any special code to 
boot from a bios-raid array because it can use standard int13 services.

> I really hope you can help me. Most importantly with question (a).
>
>
> Yours sincerely,
>
> K. Posern
>

Regards,
Dan
