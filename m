From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Thu, 01 Mar 2012 11:25:55 +0100
Message-ID: <4F4F4EB3.6030909@profihost.ag>
References: <4F4C9A11.9060302@profihost.ag> <4F4F4B1D.4050000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4F4B1D.4050000@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I am not sure whether this is the reason, but you have disks with gpt
> partition tables, while it looks like you are still using grub1? I
> didn't think grub1 was able to handle gpt.
~# grub-setup -V
grub-setup (GRUB) 1.99-14

Stefan
