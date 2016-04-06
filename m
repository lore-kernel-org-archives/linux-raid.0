From: =?utf-8?Q?=C3=89tienne?= Buira <etienne.buira@gmail.com>
Subject: Re: Repairing R1: Part tabl, & precise command
Date: Wed, 6 Apr 2016 12:31:08 +0200
Message-ID: <20160406103108.GB4108@rcKGHUlyQfVFW>
References: <57038211.6040101@tesco.net>
 <57039BCC.6040103@tesco.net>
 <5703AE18.700@tesco.net>
 <5703D98F.4020503@turmel.org>
 <5703E909.8090903@tesco.net>
 <57044EA8.2010506@websitemanagers.com.au>
 <5704E16A.3060806@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5704E16A.3060806@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 06, 2016 at 11:14:02AM +0100, Ron Leach wrote:
> On 06/04/2016 00:47, Adam Goryachev wrote:

../..

> I thought this was good advice but apt-get isn't finding smartctl.  I 
> think your surmise is likely, though, that this disk has 'reduced' in 
> size because of faults, and I've a new 3TB drive on its way.  I'll 
> replace this suspect disk as soon as it arrives.

Hi,

Package is named smartmontools on debian, and IMHO you want to regularly
check HDD health status (smartctl -a /dev/sdX).

Regards

