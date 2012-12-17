From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: imsm: 32 bit sector counts and > 2TB disks
Date: Mon, 17 Dec 2012 13:03:10 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB190490AE@IRSMSX102.ger.corp.intel.com>
References: <679865E03F4C71419D9847EA3AACB1631620DDC8@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <679865E03F4C71419D9847EA3AACB1631620DDC8@IRSMSX102.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, John Robinson <john.robinson@anonymous.org.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Thursday, December 13, 2012 10:08 AM John Robinson wrote:
> On 13/12/2012 16:45, Phillip Susi wrote:
> > It appears that the imsm format only uses 32 bits to represent the
> > sector counts used from each disk.  It appears that at least on
> > Windows, a disk > 2 TB works
> 
> It certainly does. I built a Supermicro server with 3TB drives and IMSM RAID a
> couple of weeks ago.
> 
> > so could someone from intel explain how this is supposed to work?
> 
> I'd be interested too. If I need to expand the array on the above, I was
> expecting to use a Linux live CD and mdadm to do the reshape.
> 

The IMSM metadata uses 64 bits to represent sizes (saved in *_lo and *_hi parts 32 bits each):

http://git.neil.brown.name/git?p=mdadm.git;a=commitdiff;h=5551b113dc18a6275fb04c7e7e3b76c656926e0a

Lukasz

