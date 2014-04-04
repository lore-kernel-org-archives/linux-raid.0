From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Problem Syncing raid1
Date: Fri, 4 Apr 2014 14:29:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404041427350.10236@uplift.swm.pp.se>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl> <CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com> <BAY177-W961648C4893E888EECA18C86D0@phx.gbl> <CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>
 <BAY177-W35793297D3F640EF11F48C86D0@phx.gbl> <BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl> <CAK_KU4Z9ND2ivU-09qGSTsBAyVToNnUBAzwpGkQpY_M+khwcvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4Z9ND2ivU-09qGSTsBAyVToNnUBAzwpGkQpY_M+khwcvg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>
Cc: Christian Schmitz <schnet@hotmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 3 Apr 2014, Scott D'Vileskis wrote:

> Any sectors it has trouble with it will attempt to remap to 'spare'
> data reserved on the disk.

Could you please quote some kind of external resource for your claims 
here, because they are contrary to what truth is usually communicated 
here.

Common wisdom here is that sectors that can't be read are "pending", and 
they keep being "pending" until someone writes to them, and when the 
sector is written to, it'll either succeed with the write to that sector 
and then all is fine, or it'll fail to write and then it'll mark it as 
bad, and write to spare space, ie this sector is now remapped.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
