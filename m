From: maurice <mhilarius@gmail.com>
Subject: Re: Odd booting problem
Date: Mon, 10 Oct 2011 20:12:59 -0600
Message-ID: <4E93A62B.3070509@gmail.com>
References: <4E8F8C63.1080600@gmail.com> <4E9316F8.7040800@gmail.com> <20111010171936.E9DF8581FD6@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111010171936.E9DF8581FD6@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/2011 11:19 AM, Jim Schatzman wrote:
> Maurice-
>
> I am not an expert, but I have observed that initrd/initramfs/dracut is fairly stupid, and can't handle what would seem like benign changes to the operating evironment. For example, if you install a linux kernel on a system where the / filesystem is on an LVM volume, then you move the / filesystem to a raw partition, change the grub boot commands and /etc/fstab appropriately, initrd/initramfs still fails with an "/bin/lvm exited abnormally with error 5" message. It does not seem to me that there is any reason that initrd/initramfs should care what return code lvm returns as long as it can mount the / filesystem. It also messes about with raids, generally unnecessarily.
> ..
>
> Good luck!
>
> Jim
>

Thanks Jim,

I will try some of your suggestions.

-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
