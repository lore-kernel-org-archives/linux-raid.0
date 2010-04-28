From: Luca Berra <bluca@comedia.it>
Subject: Re: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 22:59:37 +0200
Message-ID: <20100428205937.GB6065@maude.comedia.it>
References: <4BD714A3.9020801@redhat.com> <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com> <4BD874CB.5040803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BD874CB.5040803@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 28, 2010 at 01:47:55PM -0400, Doug Ledford wrote:
>DOMAIN path=pci-0000:00:1f.2-scsi-[2345]:0:0:0 action=partition
>	table=/etc/mdadm.table program=sfdisk
i admit i did not take the time to pull from your git, so tell me to
rtfc if needed.
it seems you are assuming program will take table as stdin.
would not it be better to use somethink like
action=initialize command="sfdisk %d < /etc/mdadm.table" ?
where command is invoked via a shell and %d is replaced with the device
node. (more escapes could also be useful, e.g. the sysfs node)

besides that is there any provisioning to check that the device really
is empty before running action?

Regards,
L.



-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
