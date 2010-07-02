From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/33] Autorebuild and hot-plug
Date: Fri, 02 Jul 2010 11:39:42 -0700
Message-ID: <4C2E326E.7070001@intel.com>
References: <905EDD02F158D948B186911EB64DB3D11F56FADD@irsmsx503.ger.corp.intel.com>  <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893878@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893878@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On 7/2/2010 10:11 AM, Czarnowska, Anna wrote:
> 2.  Policy definition
> Array auto rebuild configuration is based on DOMAIN lines in /etc/mdadm.conf
> config file. Only this standard config file is supported.
> The DOMAIN line defines a set of devices determined by path and platform.
> Mdadm will take the same actions for all devices in the same domain and subset.
> Subsets are parts of domain specific for hardware controllers and metadata
> spare groups (such as storage pool id to be implemented at a later stage).
> An array cannot include members and spares from more than one domain and subset.
> Spare migration happens only within a subset.
> It is possible to ignore subsets by using -force option.
> Domains are matched from top down i.e. first line from config file that matches
> given device is taken. Therefore the order of domains in config file is
> important. With no DOMAIN lines in config file four default domains are assumed,
> one for each metadata type: 0.90, 1.x, ddf, imsm.

It seems this implementation was not re-evaluated in light of Neil's 
policy framework announcement [1] sent a couple days ago.  I think there 
are some significant differences, especially with regard to how domain 
definitions stack, and how metadata handlers can tag devices and arrays 
with domain information.  Having a default domain per-metadata type does 
not gain us anything because devices with metadata are already 
associated by way of having the same metadata.

Please review the proposal on the table as I think it makes a lot of 
things easier.  Especially the requirement for tagging arrays with 
domain information.  It eliminates the ambiguity of determining an 
array's domain so we don't need to guess when an array appears to 
straddle two domains.

--
Dan

[1]: http://marc.info/?t=127796713700001&r=1&w=2
