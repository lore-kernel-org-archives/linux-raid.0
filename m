From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: RE: Software RAID 0+1 with mdadm.
Date: Wed, 26 Jan 2005 16:14:48 -0600
Message-ID: <OMEKLMBKKEOEENCKLEIDAECMCBAA.ryan@dynaconnections.com>
References: <20050126151703.GA2040@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050126151703.GA2040@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This bug that's fixed in 1.9.0, is in a bug when you create the array?  ie
do we need to use 1.9.0 to create the array.  I'm looking to do the same but
my bootdisk currently only has 1.7.soemthing on it.  Do I need to make a
custom bootcd with 1.9.0 on it?

Thanks,
-ryan

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Luca Berra
Sent: Wednesday, January 26, 2005 9:17 AM
To: linux-raid@vger.kernel.org
Subject: Re: Software RAID 0+1 with mdadm.


On Tue, Jan 25, 2005 at 02:28:21PM -0800, Brad Dameron wrote:
>Everything seems ok after boot. But again no /dev/md0 in /proc/mdstat.
>But then if I do a mdadm --assemble --scan it will then load /dev/md0.
there is a bug in mdadm, see my mail "patches for mdadm 1.8.0" or wait
for 1.9.0

L.

--
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

