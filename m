From: rich turner <rich@storix.com>
Subject: RE: raidtools vs mdadm
Date: Tue, 31 Aug 2004 15:03:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093989799.3399.27.camel@rich>
References: <8075D5C3061B9441944E1373776451186488CB@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E1373776451186488CB@cinshrexc03.shermfin.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

are there any incompatibilities related to mdadm? does it only support
the md driver at a certain level? our software supports kernel version
2.2 and later.

does it fully support creating a raid device on logical volumes, and
creating logical volumes on raid devices? i have played with this a
little and havent seen any problems but i thought i would ask to see if
anyone has seen anything.

would i expect to see the mdadm executable available on most
distributions today by default?

i realize that raid devices created with raidtools and raid devices
created with mdadm can co-exist. is there an easy way to know which
method was used to create them?

thanks for the responses


On Tue, 2004-08-31 at 12:38, Rechenberg, Andrew wrote:
> I currently use a combination of raidtools and mdadm.  I may be the
> exception rather than the rule because I'm currently using an old
> distribution (Red Hat 7.3) because of application compatibility.
> 
> I use mdadm exclusively for management of arrays though (failing, hot
> removing, hot adding, monitoring).  Fedora Core 2 is using mdadm for
> monitoring although I'm not sure what FC2 anaconda is using to setup
> RAID arrays.  I believe it still uses raidtools and rc.sysinit on FC2
> still uses raidtools.  I'm a RH die-hard so I'm not sure what other
> distros use.
> 
> I would venture to say that mdadm is becoming the defacto although it's
> not quite there yet.
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org 
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of rich turner
> > Sent: Tuesday, August 31, 2004 2:56 PM
> > To: linux-raid@vger.kernel.org
> > Subject: raidtools vs mdadm
> > 
> > i work for a software company that develops backup and 
> > disaster recovery software for linux. our product supports 
> > software raid, but i must say that we currently only support 
> > it when devices are created with raidtools. i only recently 
> > heard about mdadm and am very impressed with its flexibility 
> > and funtionality.
> > 
> > my question is how popular is mdadm in production 
> > environments as this compares to raidtools?
> > 
> > is mdadm used to configure software raid on any distribution 
> > installations?
> > 
> > is mdadm trending to become the defacto standard for software 
> > raid on linux?
> > 
> > rich turner
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-raid" in the body of a message to 
> > majordomo@vger.kernel.org More majordomo info at  
> > http://vger.kernel.org/majordomo-info.html
> > 

