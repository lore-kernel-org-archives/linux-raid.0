From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Bit-Rot
Date: Sun, 5 Mar 2017 09:15:39 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1703050913530.30226@uplift.swm.pp.se>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com> <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk> <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 3 Mar 2017, Gandalf Corvotempesta wrote:

> This is what ZFS does. This is what Gluster does. This is what BRTFS does.
> Adding this in mdadm could be an interesting feature.

This has been discussed several times. Yes, it would be interesting. It's 
not easy to do because mdadm maps 4k blocks to 4k blocks. Only way to 
"easily" add this I imagine, would be to have an additional "checksum" 
block, so that raid6 would require 3 extra drives instead of 2.

The answer historically has been "patches welcome".

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
