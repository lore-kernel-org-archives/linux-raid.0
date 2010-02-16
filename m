From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Slow(?) raid5 to raid6 reshape speed
Date: Tue, 16 Feb 2010 12:53:27 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002161251570.4986@uplift.swm.pp.se>
References: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de>
Sender: linux-raid-owner@vger.kernel.org
To: Michael <michael@rw23.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Feb 2010, Michael wrote:

> i think the kernel's raid io is not visible at iotop or iam wrong?

Use "iostat -x 5" to see what is going on, personally I used 
"sync_speed_min" so my drives were around 50-80% busy because for some 
reason it tried to use much lower speed a otherwise.

If your drives are already at 100% then there is nothing more to do than 
to wait it out...

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
