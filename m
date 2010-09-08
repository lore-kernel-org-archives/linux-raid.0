From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 5 drives lost in an inactive  15 drive raid 6 system due to
 cable problem - how to recover?
Date: Wed, 8 Sep 2010 22:22:16 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1009082218280.13746@uplift.swm.pp.se>
References: <4C87C656.2030405@stern.nyu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C87C656.2030405@stern.nyu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Norman White <nwhite@stern.nyu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 8 Sep 2010, Norman White wrote:

> Any pointers on how to proceed would be helpful. Restoring 30TB takes 
> along time.

Look into the archives of this list, this has happened to numerous people 
and most have gotten out of it ok.

Make sure you have a recent kernel and the latest mdadm.

At this point I've several times successfully done --assemble --force in 
your situation with good result.

--create --assume-clean is the absolute last resort when everything else 
fails, is my recommendation.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
