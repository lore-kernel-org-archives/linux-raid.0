From: Brad Dameron <brad@seatab.com>
Subject: RE: Software RAID 0+1 with mdadm.
Date: Thu, 27 Jan 2005 09:02:55 -0800
Message-ID: <1106845375.25578.3.camel@serpent>
References: <OMEKLMBKKEOEENCKLEIDAECMCBAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OMEKLMBKKEOEENCKLEIDAECMCBAA.ryan@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

By the way the patches did not fix my boot issue with the RAID 1+0. I am
using SuSe 9.2 if this helps. I've had to add in a few extra lines into
my boot.local to get it show up at boot.

Brad Dameron
SeaTab Software
www.seatab.com

On Wed, 2005-01-26 at 14:14, J. Ryan Earl wrote:
> This bug that's fixed in 1.9.0, is in a bug when you create the array?  ie
> do we need to use 1.9.0 to create the array.  I'm looking to do the same but
> my bootdisk currently only has 1.7.soemthing on it.  Do I need to make a
> custom bootcd with 1.9.0 on it?
> 
> Thanks,
> -ryan
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Luca Berra
> Sent: Wednesday, January 26, 2005 9:17 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: Software RAID 0+1 with mdadm.
> 
> 
> On Tue, Jan 25, 2005 at 02:28:21PM -0800, Brad Dameron wrote:
> >Everything seems ok after boot. But again no /dev/md0 in /proc/mdstat.
> >But then if I do a mdadm --assemble --scan it will then load /dev/md0.
> there is a bug in mdadm, see my mail "patches for mdadm 1.8.0" or wait
> for 1.9.0
> 
> L.
> 
> --
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

