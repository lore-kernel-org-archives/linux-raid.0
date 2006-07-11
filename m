From: Tejun Heo <htejun@gmail.com>
Subject: Re: Test feedback 2.6.17.4+libata-tj-stable (EH, hotplug)
Date: Tue, 11 Jul 2006 11:52:16 +0900
Message-ID: <44B31260.5030409@gmail.com>
References: <bb145bd20607101439n475b1771g1c754af31911288@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20607101439n475b1771g1c754af31911288@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
> The fact that the disk had changed minor numbers after it was plugged
> back in bugs me a bit. (was sdc before, sde after). Additionally udev
> removed the sdc device file, so I had to manually recreate it to be
> able to remove the 'faulty' disk from its md array.

That's because md is stilling holding onto sdc in failed mode.  A 
hotplug script which checks whether a removed device is in md array and 
if so removes it from the array will solve the problem.  Not sure 
whether that would be the correct approach though.

Thanks.

-- 
tejun
