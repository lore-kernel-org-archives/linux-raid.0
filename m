From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re[2]: Issue removing failed drive and re adding on raid 6
Date: Sat, 4 Jul 2015 07:11:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507040706560.11810@uplift.swm.pp.se>
References: <emedabf90f-c9d1-46af-80f9-b33e9d25677d@littlez>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <emedabf90f-c9d1-46af-80f9-b33e9d25677d@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 3 Jul 2015, Justin Stephenson wrote:

> I have tried assembling with --scan --force and by naming the drives 
> sd{b,c,d,e,f,g,h}1 Neither method has worked.

If you want help with that, then you need to provide the output of 
commands and dmesg so we can try to figure out why it won't start.

I would recommend you start by using a new mdadm compiled from source:

"git clone git://neil.brown.name/mdadm mdadm"

Most --assemble problems like this is workarounded by using a new mdadm.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
