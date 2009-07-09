From: "NeilBrown" <neilb@suse.de>
Subject: RE: Question on RAID-5 using ADMA
Date: Thu, 9 Jul 2009 13:53:42 +1000 (EST)
Message-ID: <9a56cb1758c9d7c935da72e9001d8e6b.squirrel@neil.brown.name>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
    <C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5>
    <8ba75cd82b7938995077e9e157f5b93f.squirrel@neil.brown.name>
    <AC5E1C3367E37D44970B81A6ADD1DA2C07B08866@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08866@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Thu, July 9, 2009 1:37 pm, Tirumala Reddy Marri wrote:
> Hi Niel,
>
> I am wondering what is the priority between RAID-5 recovery and input IO
> from application.
> I am seeing these filesystem errors  when RAID-5 recovery is going on I
> tried to install ext3 file-system
> and send data to /mnt/tmpmnt(/dev/md0 mount point) using "dd" command. I
> noticed that when amount of data is less than
> RAID-5 recovery size no file system errors seen. When amount of data
> copied crosses RAID-5 recovery size I am seeing
> file-system errors.

I'm not sure what you mean by "priority".

application writes go to the stripe-cache.
recovery writes go to the stripe-cache
data from the stripe-cache is written to the devices.

there is no really issue of 'priority'.  Just interlocking to make sure
they don't both updates the same block at the same time, and they
don't.

NeilBrown


