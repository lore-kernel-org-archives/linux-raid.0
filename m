From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Hard Drive Partition Table shows partition larger than drive
Date: Sun, 26 Apr 2020 21:21:49 +0100
Message-ID: <5EA5ED5D.8060006@youngman.org.uk>
References: <6ee9392d-8867-f0b5-193e-17a516bb7e0e@steinmetznet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6ee9392d-8867-f0b5-193e-17a516bb7e0e@steinmetznet.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Steinmetz <rob@steinmetznet.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/04/20 18:49, Robert Steinmetz wrote:

> 
> boot and raid flags are set.
> Obviously something is wrong.
> I originally use the drive to replace another smaller drive in a Raid 1
> array and that array was created with mdadm and maybe lvm2.
> Is there a reasonable way to see if the drive has anything usable in it?
> 
Run lsdrv over the drive and see what that reports.

https://raid.wiki.kernel.org/index.php/Asking_for_help

If you post that here, hopefully somebody can help you reconstruct
whatever was there.

Cheers,
Wol
