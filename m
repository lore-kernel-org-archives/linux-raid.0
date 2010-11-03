From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Determining which spindle is out of order
Date: Wed, 3 Nov 2010 16:29:21 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1011031628300.2639@uplift.swm.pp.se>
References: <loom.20101103T115828-494@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20101103T115828-494@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <Shelso@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Nov 2010, Nat Makarevitch wrote:

> We want to avoid extracting a working spindle by mistakenly thinking it 
> is the faulty one...

I tend to look at the blinking lights, it's usually quite obvious which 
drive isn't in the array anymore by the fact that the activity light is 
not blinking. Apart from that, as someone else said, use serial numbers.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
