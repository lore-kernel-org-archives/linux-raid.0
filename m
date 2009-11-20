From: Luca Berra <bluca@comedia.it>
Subject: Re: [patch 1/1] [mdadm] Add partition checks when creating a new
	array
Date: Fri, 20 Nov 2009 18:03:50 +0100
Message-ID: <20091120170350.GA20882@maude.comedia.it>
References: <EB332302649177439359CE520D92A0AF9F559760@irsmsx503.ger.corp.intel.com> <19196.51508.947560.851117@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19196.51508.947560.851117@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Trela, Maciej" <Maciej.Trela@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, Nov 13, 2009 at 01:49:24PM +1100, Neil Brown wrote:
>Is there a good library that we could use?
>libparted might be a possibility, but it seems rather over-weight.
>/lib/libparted-1.9.so.12.0.0 is larger than /sbin/mdadm !!!
>
>Are there any other libraries for reading different partition tables?
>I guess we can open-code it if we have to but I'd be happy if another
>solution could be found.

i don't think so,
but there are two tools
partx from util-linux
kpartix from multipath-tools (which is based on the former)

so we could either grab code from those or just invoke
partx -l (i believe every distro installs util-linux by default)

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
