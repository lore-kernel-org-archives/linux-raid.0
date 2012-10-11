From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Thu, 11 Oct 2012 08:12:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1210110810210.21297@uplift.swm.pp.se>
References: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com> <507561EB.1050308@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <507561EB.1050308@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 10 Oct 2012, Stan Hoeppner wrote:

> Precisely what it says.  It doesn't tell you WHY it was blocked, as it 
> can't know.  The fact that your md array was in recovery and having 
> problems with one of the member drives is a good reason for xfssyncd to 
> block.

Doesn't he still have 3 good drives? So since sdb was failed, there would 
be no reason for sdb to cause blocking or writes to the (now degraded) 
raid5? OP said he saw write IO errors to the array (?), which I thought 
was strange.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
