From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Antw: Re: Problems creating MD-RAID1: "device .. not suitable
 for any style of raid array" / "Device or resource busy"
Date: Wed, 11 May 2011 08:38:42 +0200
Message-ID: <4DCA4B12020000A100005D1D@gwsmtp1.uni-regensburg.de>
References: <4DC4029F020000A100005CA7@gwsmtp1.uni-regensburg.de>
 <4DC40866.30601@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC40866.30601@turmel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> Phil Turmel <philip@turmel.org> schrieb am 06.05.2011 um 16:40 in Nachricht
<4DC40866.30601@turmel.org>:
> Hi Ulrich,
> 
> On 05/06/2011 08:15 AM, Ulrich Windl wrote:
> > Hello!
> > 
> > I'm having strange trouble with SLES11 SP1 amd MD RAID1 (mdadm - v3.0.3 
> (mdadm-3.0.3-0.22.4), 2.6.32.36-0.5-xen):
> 
> I'm not a Xen user, nor SLES, but I thought I'd poke around for this.
> 
> [trim /]
> 
> > Corresponding Syslog messages:
> > May  4 17:18:54 rksapv01 kernel: [  231.942241] md: bind<xvdf>
> > May  4 17:18:54 rksapv01 kernel: [  231.942265] md: could not bd_claim 
> xvdg.
> > May  4 17:18:54 rksapv01 kernel: [  231.942269] md: md_import_device 
> returned
> > -16
> 
> This seems to be the key.  I found this thread from XenSource:
> 
> http://lists.xensource.com/archives/html/xen-users/2010-08/msg00063.html 
> 
> which suggests your guest kernel's configuration doesn't include MD support.
> 
> In your guest, please show the output of:
> 
> # zcat /proc/config.gz |grep _MD[=_]
> 
> 
> Phil
> 

Hi Phil,

I thought about it: If I suceeded to create one MD-RAID, the required modules should be there, right? Also the kernel message suggests that the kernel could not access the device (because it's used already?). Anyway:
# zcat /proc/config.gz |grep _MD[=_]
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID6_PQ=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m

Regards,
Ulrich

 
 

