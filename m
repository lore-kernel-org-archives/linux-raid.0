From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Issue removing failed drive and re adding on raid 6
Date: Fri, 3 Jul 2015 22:47:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507032246050.11810@uplift.swm.pp.se>
References: <em17230779-c755-4dbc-9c40-6a0518cfd840@littlez>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <em17230779-c755-4dbc-9c40-6a0518cfd840@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 3 Jul 2015, Justin Stephenson wrote:

>          State : active, degraded, Not Started

What does "cat /proc/mdstat" say? It looks like the array isn't up and 
running, in that case you have to assemble it and get it up and running 
before you can --add the new drive.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
