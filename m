From: dean gaudet <dean@arctic.org>
Subject: Re: Raid5 & Debian Yaird Woes
Date: Fri, 3 Feb 2006 16:22:48 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0602031622100.19604@twinlark.arctic.org>
References: <200602031229.37972.mylists@blue-matrix.org>
 <Pine.LNX.4.64.0602021808100.6557@twinlark.arctic.org>
 <Pine.LNX.4.64.0602021859490.15679@twinlark.arctic.org>
 <200602040958.20183.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200602040958.20183.mylists@blue-matrix.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lewis Shobbrook <mylists@blue-matrix.org>
Cc: linux-raid@vger.kernel.org, dr@jones.dk
List-Id: linux-raid.ids

On Sat, 4 Feb 2006, Lewis Shobbrook wrote:

> Is there any way to avoid this requirement for input, so that the system skips 
> the missing drive as the raid/initrd system did previously?  

what boot errors are you getting before it drops you to the root password 
prompt?

is it trying to fsck some filesystem it doesn't have access to?

-dean
