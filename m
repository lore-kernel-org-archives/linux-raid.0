From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH 1/2] imsm: delete subarray functionality
Date: Thu, 1 Apr 2010 22:31:40 +0100
Message-ID: <66C59AD0932712458090B447266D638CD3CE3017@irsmsx504.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638CD3C7EAF4@irsmsx504.ger.corp.intel.com>
 <20100401060922.GA15461@maude.comedia.it> <4BB4CA69.7060705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB4CA69.7060705@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, Ciechanowski,
List-Id: linux-raid.ids

>-----Original Message-----
>From: Doug Ledford [mailto:dledford@redhat.com]
>Sent: Thursday, April 01, 2010 6:32 PM
>To: Hawrylewicz Czarnowski, Przemyslaw; Neil Brown; linux-
>raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
>Subject: Re: [PATCH 1/2] imsm: delete subarray functionality
>
>On 04/01/2010 02:09 AM, Luca Berra wrote:
>> On Wed, Mar 31, 2010 at 09:50:40PM +0100, Hawrylewicz Czarnowski,
>> Przemyslaw wrote:
>
>>> int mdmon_pid(int devnum)
>>> @@ -1502,7 +1523,11 @@ int mdmon_pid(int devnum)
>>>        char pid[10];
>>>        int fd;
>>>        int n;
>>> -       sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
>>> +       char *devname = devnum2devname(devnum);
>>> +
>>> +       sprintf(path, "%s/%s.pid", pid_dir, devname);
>>> +       free(devname);
>>> +
>>>        fd = open(path, O_RDONLY | O_NOATIME, 0);
>>>
>>>        if (fd < 0)
>> why?
>
>Looks like it leaks memory in the old implementation.
For both mdmon_running and mdmon_pid there is a memory leak with strdup.
Did I miss something?

>
>--
>Doug Ledford <dledford@redhat.com>
>              GPG KeyID: CFBFF194
>	      http://people.redhat.com/dledford
>
>Infiniband specific RPMs available at
>	      http://people.redhat.com/dledford/Infiniband


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer
