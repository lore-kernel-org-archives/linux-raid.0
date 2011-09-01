From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 19:21:12 +0200
Message-ID: <4E5FBF08.5080709@macroscoop.nl>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FAFE9.3040604@macroscoop.nl> <4E5FB762.4050003@yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FB762.4050003@yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@yuiop.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1-9-2011 6:48, John Robinson wrote:
> you should be using partition type DA (Non-FS data)
using gdisk (GPT) or fdisk (MBR) ?


> and an initrd to assemble your arrays. 

Booting from the array is not required. I guess the Fedora init scripts
will assemble the array from /etc/mdadm.conf

Thanks,
Pim

