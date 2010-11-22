From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Devel 3.2 branch issues
Date: Mon, 22 Nov 2010 10:47:31 -0800
Message-ID: <4CEABAC3.5050602@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>	<20101117212242.5ad7b210@notabene.brown>	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE90089@irsmsx504.ger.corp.intel.com> <20101122142953.7934c8ca@notabene.brown>  <905EDD02F158D948B186911EB64DB3D174BA8CE8@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D174BA8CE8@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On 11/22/2010 9:18 AM, Labun, Marcin wrote:
>> - the getinfo_super_disks method.  I couldn't see why you need this.
>> All the
>>    info about the state of the arrays should already be available.
>>    If there is something that you need that we don't have, please
>> explain and
>>    we can see how best to add it back in.
>
> For external metadata we have added a metadata handler to get a disk state (a spare or not a spare) based on current metadata state on disk.
> Ioctl(GET_DISK_INFO) does not have a disk state info for containers (returns 0 - so we don't know if it is a spare or a failed disk).
> We know that a disk is an array member based on check its state in the array.

I'm still catching up on the devel-3.2 getinfo/load_super reworks, but I 
think this info would probably fit into the new 'map' parameter of 
getinfo_super().  Spares can be indicated as 'working' in the map.  I.e. 
if map returns 1 for a container member and that disk is not currently 
in use in a subarray then we can assume it is a spare at the container 
level.

Alternatively we could just return 2 in the map to indicate spare, but I 
think in the locations we care about we already know that it is not 
currently in use in a subarray.

--
Dan
