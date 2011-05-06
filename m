From: Phil Turmel <philip@turmel.org>
Subject: Re: Problems creating MS-RAID1: "device .. not suitable for any style
 of raid array" / "Device or resource busy"
Date: Fri, 06 May 2011 10:40:38 -0400
Message-ID: <4DC40866.30601@turmel.org>
References: <4DC4029F020000A100005CA7@gwsmtp1.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC4029F020000A100005CA7@gwsmtp1.uni-regensburg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Ulrich,

On 05/06/2011 08:15 AM, Ulrich Windl wrote:
> Hello!
> 
> I'm having strange trouble with SLES11 SP1 amd MD RAID1 (mdadm - v3.0.3 (mdadm-3.0.3-0.22.4), 2.6.32.36-0.5-xen):

I'm not a Xen user, nor SLES, but I thought I'd poke around for this.

[trim /]

> Corresponding Syslog messages:
> May  4 17:18:54 rksapv01 kernel: [  231.942241] md: bind<xvdf>
> May  4 17:18:54 rksapv01 kernel: [  231.942265] md: could not bd_claim xvdg.
> May  4 17:18:54 rksapv01 kernel: [  231.942269] md: md_import_device returned
> -16

This seems to be the key.  I found this thread from XenSource:

http://lists.xensource.com/archives/html/xen-users/2010-08/msg00063.html

which suggests your guest kernel's configuration doesn't include MD support.

In your guest, please show the output of:

# zcat /proc/config.gz |grep _MD[=_]


Phil
