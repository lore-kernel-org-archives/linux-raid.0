From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 18:19:45 -0700
Message-ID: <4BD8DEB1.40801@intel.com>
References: <4BD714A3.9020801@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>	<4BD874CB.5040803@redhat.com>	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>	<4BD8A336.7080309@redhat.com> <20100429110153.7148bb9b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100429110153.7148bb9b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

Neil Brown wrote:
> I'm not sure how this fits with imposing platform constraints.
> As platform constraints are closely tied to metadata types, it might be OK
> to have a metadata-specific tags (imsm=???) and leave to details to the
> metadata handler???
> 
> Dan: help me understand these platform constraints: what is the most complex
>   constraint that you can think of that you might want to impose?

At this point we really only need one constraint: prevent controller 
spanning.  If for example I take an existing imsm member off of ahci and 
reattach it via a usb-to-sata enclosure mdadm needs a policy to prevent 
associating that drive with anything on ahci.

In a pinch this policy can be disabled, but you wouldn't want to rebuild 
across usb or any other controller because the option-rom only talks 
ahci and will mark the drive missing.

So something like DOMAIN spanning=imsm, to tell mdadm to follow imsm 
rules for this domain.  Where 'spanning' is policy tag??

--
Dan

