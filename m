From: John McNulty <johnmcn1@googlemail.com>
Subject: Re: What will happen with spares in this scenario?
Date: Tue, 30 Jun 2009 09:16:09 +0100
Message-ID: <ab50889f0906300116p42b48afnf1605ea1e8cdf60c@mail.gmail.com>
References: <ab50889f0906290828s44e10b14n1af6d23556e3f0ee@mail.gmail.com>
	 <87zlbruinb.fsf@frosties.localdomain>
	 <BD450977-FA0D-4F63-8ADB-1314FA43E654@googlemail.com>
	 <87r5x2xs7i.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r5x2xs7i.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 30, 2009 at 5:26 AM, Goswin von Brederlow<goswin-v-b@web.de> wrote:
>
> Hmm, do I understand this right that you want 2 partitions. One for
> /boot and one for everything else on lvm?
>
> Just a crazy idea. But why not put /boot on lvm too and use grub2 or
> lilo as bootloader? Or does Kickstart not allow that?

I didn't think that booting from an LVM device was supported, whether
it's sitting on an md raid device or not.  How is the bootloader meant
to find the kernel and initrd without first constructing the VG and
mounting the /boot Logical Volume.  It's been quite a while since I
looked (we get into the habit of doing things the same way) but last
time I checked this didn't work.

Rgds,

John
