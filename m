From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: New mailing list for 2.6 Medley RAID (Silicon Image 3112 etc.)
 BIOS RAID development
Date: Mon, 09 Feb 2004 11:57:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4027BBDE.1090300@pobox.com>
References: <Pine.LNX.4.40.0402091220130.8715-100000@jehova.dsm.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.40.0402091220130.8715-100000@jehova.dsm.dk>
To: Thomas Horsten <thomas@horsten.com>
Cc: Arjan van de Ven <arjanv@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Horsten wrote:
> My gut feeling is that if it is provided by the BIOS and reliable
> autodetection is possible, it should be autodetected. Why require the user
> to discover and supply information that the kernel could easily and
> reliably find out by itself? Besides, if there is no autodetection, the

The autodetection will occur, reliably and without additional user 
information, from initramfs.

As Arjan said, we are moving this type of stuff out of the kernel.

	Jeff


