From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which? headaches galore!
Date: Mon, 23 Jan 2006 15:49:51 -0500
Message-ID: <20060123204951.GA12194@havoc.gtf.org>
References: <43D53AEC.7060302@xs4all.nl> <20060123204404.41cfc6ef@ted.secure-tunnel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060123204404.41cfc6ef@ted.secure-tunnel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shawn Usry <shawn@joebacardi.com>
Cc: John Hendrikx <hjohn@xs4all.nl>, PFC <lists@peufeu.com>, Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 23, 2006 at 02:44:04PM -0600, Shawn Usry wrote:
> The drives physically support SMART, but apparently the roadblock
> is lacking support in the libata drivers.

Support is now present in libata.  Most likely the user has forgotten to
add "-d ata" to smartd and smartctl.

	Jeff



