From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: Question on RAID-5 using ADMA
Date: Wed, 8 Jul 2009 20:37:15 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08866@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>    <C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5> <8ba75cd82b7938995077e9e157f5b93f.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <8ba75cd82b7938995077e9e157f5b93f.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Guy Watkins <linux-raid@watkins-home.com>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hi Niel,

I am wondering what is the priority between RAID-5 recovery and input IO
from application.
I am seeing these filesystem errors  when RAID-5 recovery is going on I
tried to install ext3 file-system 
and send data to /mnt/tmpmnt(/dev/md0 mount point) using "dd" command. I
noticed that when amount of data is less than 
RAID-5 recovery size no file system errors seen. When amount of data
copied crosses RAID-5 recovery size I am seeing 
file-system errors. 

Regards,
Marri

	

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of NeilBrown
Sent: Wednesday, July 08, 2009 4:28 PM
To: Guy Watkins
Cc: Tirumala Reddy Marri; linux-raid@vger.kernel.org; 'Dan Williams'
Subject: RE: Question on RAID-5 using ADMA

On Thu, July 9, 2009 9:11 am, Guy Watkins wrote:
> I think you are doing --assume-clean wrong.
>
> Anyway, if you are bypassing the parity build with --assume-clean then
how
> can you expect it to work with a failed disk?

That was my first thought too, but it doesn't actually follow.

With only 3 devices, every write will construct new correct parity, so
every block that was actually written will read back with the correct
data after a device failure.

There must be something going wrong in the xor calculations.


NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
