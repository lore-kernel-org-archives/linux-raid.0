From: Joe Landman <joe.landman@gmail.com>
Subject: Re: SES Enclosure Management.
Date: Wed, 15 Feb 2012 09:54:15 -0500
Message-ID: <4F3BC717.7060609@gmail.com>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com> <20120215073130.792d4fae@notabene.brown> <4F3AC741.6050204@gmail.com> <4F3AC9CB.3070707@gmail.com> <4F3ACAF6.4030004@gmail.com> <4F3ACCC4.6070901@aeoncomputing.com> <4F3ACDD7.5040506@gmail.com> <4F3AD0F0.7010306@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3AD0F0.7010306@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/14/2012 04:24 PM, Jeff Johnson wrote:

>> I work for one of those vendors, it's my job to have our **** together.
>>
> The trick is to map the disk element names to the block device names.
> Different SAS HBAs and drivers can enumerate the devices differently.
> Persistence settings can muck things up as well. Sometimes a failed
> block device at /dev/sdf can appear as /dev/sdr when replaced. You could
> use udev rules to create alternate block device names but so far, for
> important data, I've seen no substitute for a pair of knowledgeable
> human eyes analyzing a failure and confirming a failed drive by
> corelating WWNs, etc.

The tools we've been working on have been trying to correlate this by 
various methods though these vary by HBA and other issues.  UDEV rules 
can often produce some interesting results (and not in a good way, and 
not just for disks).

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

