From: Bryon Roche <kain@kain.org>
Subject: Re: differnet UUIDs and no of spares :(
Date: Wed, 21 Jan 2009 18:04:08 +0000 (UTC)
Message-ID: <gl7o2n$6et$2@ger.gmane.org>
References: <1231954002.17710.13.camel@brandy.snifter.org>
	<496E6C37.9030608@tmr.com> <35147.127.0.0.1.1232535970.squirrel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 21 Jan 2009 11:06:10 +0000, eamonn wrote:

> I don't suppose anybody else has any ideas? I've been holding off
> attempting anything in the hope of somebody handing me a silver bullet,
> but failing that ... ;)
No silver bullets. your best chance is to use the logs like you mention 
to do a forced read-only assemble.  For this reason, it's also usually a 
good idea to save the arguments you used for mdadm --create somewhere, 
especially if you made the array with a non-default layout.  At least 
this will let you stream the data of the array onto something else.

A forced assembly necessarily destroys the superblock and any metadata 
that could be used to resume the build.  Your best bet here will be to 
make sure you got the device order correct, probably in accordance to the 
oldest list.  This assumes that you didn't start rebuilding onto any 
disks in such a way as to change that order.

