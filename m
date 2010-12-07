From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] fix: mdadm -Ss for external metadata don't stop container
Date: Tue, 07 Dec 2010 08:09:07 -0800
Message-ID: <4CFE5C23.4070603@intel.com>
References: <66C59AD0932712458090B447266D638C010BD52A8E@irsmsx504.ger.corp.intel.com> <20101207211611.475410d1@notabene.brown>  <66C59AD0932712458090B447266D638C010BD52E6C@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C010BD52E6C@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On 12/7/2010 3:07 AM, Hawrylewicz Czarnowski, Przemyslaw wrote:
>> I've applied this, but I'm not 100% sure it is completely safe.
>> mdmon holds the O_EXCL open to be sure that mdadm isn't creating or
>> assembling another array in the container.
>> mdadm will get an O_EXCL and then try sending a signal to mdmon.  If it
>> succeeds, it knows mdmon is still running.  But this patch might open a
>> window where mdadm can get O_EXCL, and a signal still works.
> On the manual pages, behavior of O_EXCL is only defined in connection with O_CREAT flag, which is not present in open_dev_excl (of course:). I have just make test for open(name, O_RDWR | O_EXCL) few times on the same file and it does not block other processes...

Try the same test on a device special file.

--
Dan
