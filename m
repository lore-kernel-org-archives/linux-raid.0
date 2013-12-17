From: Dimitri John Ledkov <xnox@debian.org>
Subject: Re: What can be used instead of /dev/disk/by-path/* symlinks?
Date: Tue, 17 Dec 2013 09:53:43 +0000
Message-ID: <CANBHLUi6h7B2CFTShqV+1RxFiAqSe7pw=siPXx8OFrfDqZCvfA@mail.gmail.com>
References: <D9FFE20C522965449E182ACE73889AEB1A69A1E3@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A69A1E3@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

Hello,

On 17 December 2013 09:10, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> Hi Neil,
>
> The /dev/disk/by-path/* symlinks are not created for ATA devices in systems using systemd v182+, so mdadm cannot use them in case of policies and udev rules (mdadm -If --path=...)
>
> What do you think - what should be used instead? The symlinks from /sys/block/* ?
>

I am using a patched udev from systemd daemon collection v204, it
still has "by-path" symlinks setup in the persistent storage rules.
Similarly upstream systemd daemon collection v204 also sets up
"by-path" symlinks in the persistent storage rules.

What is your udev rules config? are any of persistent storage rules
overridden? or not waiting for udev to settle? maybe the "builtin"
command "path_id" not returning / detecting the paths of ATA devices
in question?

-- 
Regards,

Dimitri.
