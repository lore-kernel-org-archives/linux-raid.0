From: Thomas Horsten <thomas@horsten.com>
Subject: Re: New mailing list for 2.6 Medley RAID (Silicon Image 3112 etc.)
 BIOS RAID development
Date: Mon, 9 Feb 2004 18:00:02 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.40.0402091756380.13341-100000@jehova.dsm.dk>
References: <20040209121144.GA24503@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040209121144.GA24503@devserv.devel.redhat.com>
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Feb 2004, Arjan van de Ven wrote:

> It doesn't really belong there.

I didn't really know about how initramfs was supposed to work, now I've
read up on it and I agree that it is the best solution.

I'll do the ataraid detection userside, but I am still not sure whether
some additions to the device mapper might be needed.

For Medley RAID it's pretty straightforward to map striped sets, but how
to deal with ataraids like Highpoint where they use non-standard zone
models for the RAID0 sets?

// Thomas

