From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: open_dev_excl in reshape_container() fails
Date: Fri, 14 Jan 2011 14:49:43 -0800
Message-ID: <4D30D307.6030602@intel.com>
References: <905EDD02F158D948B186911EB64DB3D176E5A1BC@irsmsx503.ger.corp.intel.com> <AANLkTinKyBbX7S-yaM_FG=HU0ABuAzw+FxaUgdZPzy0Q@mail.gmail.com> <905EDD02F158D948B186911EB64DB3D176E5A4CA@irsmsx503.ger.corp.intel.com>  <905EDD02F158D948B186911EB64DB3D176E5A6CF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176E5A6CF@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On 1/14/2011 2:36 AM, Kwolek, Adam wrote:
> Hi,
>
> I think I've found problem root cause.
> As I'm working on "Online Capacity Expansion", my tests uses mounted arrays - this is in conflict with open_dev_ext()
> and fails this function. Evrything is ok  This means that reshape operation cannot be performed online (or this is valid on my system only?).
>
> I do not know why on begin (in main() of mdadm.c) this function can succeed and later not (later system blocks array ?).
> More, when I've made some open_dev_exe()+close() earlier, it works later also (please look used code below/treat patch as demo/).
>
> Summarizing problem is related to mounted arrays only.

Why do we need an exclusive open on the subarrays, that defeats the 
purpose of online capacity expansion?  The exclusive open on the 
container prevents new arrays from being created and other races, but I 
do not see why we would need exclusive access to the subarray.

I would look at the code, but I am distracted by another firefight at 
the moment.

--
Dan

