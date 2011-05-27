From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 11:45:49 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1105271142110.25096@unicorn.drogon.net>
References: <42.A9.00666.D9CEEDD4@cdptpa-omtalb.mail.rr.com> <4DDEED47.1040809@fnarfbargle.com> <20110527095840.427d90be@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110527095840.427d90be@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 27 May 2011, Roman Mamedov wrote:

> On Fri, 27 May 2011 08:16:07 +0800
> Brad Campbell <brad@fnarfbargle.com> wrote:
>
>> On 27/05/11 08:13, Leslie Rhorer wrote:
>>>>
>>> 	I can't speak to Ubuntu, but Debian evidently does not.  I don't
>>> know what "pvs" is, but neither bash nor Python recognize it as a file
>>> anywhere in the path.
>> apt-get install lvm2.
>
> Sure, but lsdrv shouldn't assume lvm2 is installed or require it to be
> installed. Not everyone uses LVM, and simply installing it automatically adds
> things to initramfs (PV/VG/LV detection?), which can slow down boot-up process.

As well as not using LVM, some of us don't even use udev... Or kernels 
with modules...

Can someone post the output of this utility so I can see what it's 
actually doing?

(I don't have python on all my servers either)

Cheers,

Gordon
