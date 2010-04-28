From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 14:13:51 -0700
Message-ID: <4BD8A50F.1030904@intel.com>
References: <4BD714A3.9020801@redhat.com> <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com> <4BD874CB.5040803@redhat.com> <905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com> <4BD8A336.7080309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD8A336.7080309@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

Doug Ledford wrote:
> On 04/28/2010 02:34 PM, Labun, Marcin wrote:
>> Should an array be split (not assembled) if a domain paths are dividing array into two separate DOMAIN?
> 
> I don't think so.  Amongst other things, this would make it possible to
> render a machine unbootable if you had a type in a domain path.  I think
> I would prefer to allow established arrays to assemble regardless of
> domain path entries.

This is what I was calling the 'enforce=' policy in previous mails. 
Whether to block, warn, or ignore arrays that span a domain.  I can see 
someone wanting to have something like enforce=platform to make sure we 
Linux tries to assemble an array that the option-rom can't put together.

>>>  I'm happy to rework the code to support it if there's a valid use
>>> case, but so far my design goal has been to have a path only appear in
>>> one domain, and to then perform the appropriate action based upon that
>>> domain.
>> What is then the purpose of metadata keyword?
> 
> Mainly as a hint that a given domain uses a specific type of metadata.

Yeah, to protect against cases where a stale disk is plugged into an 
unexpected port.

--
Dan

