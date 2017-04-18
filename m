From: Phil Susi <psusi@ubuntu.com>
Subject: Re: Zombie dm device?
Date: Tue, 18 Apr 2017 09:00:56 -0400
Message-ID: <5b349798-c9de-04ef-d1dd-bc7774001903@ubuntu.com>
References: <3cf28b7e-9716-3595-018a-fecb32b61751@ubuntu.com>
 <ff1512f1-f499-43f9-daef-85cdaf1cb2ef@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff1512f1-f499-43f9-daef-85cdaf1cb2ef@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/17/2017 10:36 PM, Zhilong Liu wrote:
> can you find the /sys/block/md99/md/array_state? issue the
> # echo clear > /sys/block/md99/md/array_state  to stop array.
> The test suit is in improving progress, a few test cases cannot
> work well currently. you can talk about your requirement, and
> I would record it. more details, more appreciate. :-)

It already said it was clear.  Attempting to clear it again apparently
rebooted the virtual machine and for some reason, syslog and kern.log
are empty and the previous one is last dated 8 days ago.

Odd that it just rebooted too since I'm pretty sure a panic should have
just halted the system with the panic message written to the vnc console.

