From: Phil Turmel <philip@turmel.org>
Subject: Re: Big-endian RAID5 recovery problem
Date: Mon, 1 May 2017 22:47:22 -0400
Message-ID: <9683b4c3-d4b6-47a6-63cf-90e95eed5b72@turmel.org>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
 <0ab1ea1b-8035-512e-0b0a-819e15929f41@youngman.org.uk>
 <8aa82733243a09e48ba87d6282d8f791@mail.athompso.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8aa82733243a09e48ba87d6282d8f791@mail.athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Thompson <athompso@athompso.net>, Anthony Youngman <antlists@youngman.org.uk>
Cc: MUUG Roundtable <roundtable@muug.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/01/2017 06:33 PM, Adam Thompson wrote:

> Spinning up a QEMU instance of Linux-PPC or Linux-MIPS with the disks in
> pass-through mode has also been mentioned, but... ugh.  Anecdotal
> reports from the web suggest that doing so would just be opening up a
> second rabbit hole in addition to the one I'm already headed down.

Actually, this is a very good idea.  If you can successfully assemble
within one of these VMs, you could use the --update=metadata option to
convert to v1.0 superblocks.  Cleanly shut down, and then the arrays
would be usable in the host.

Phil

